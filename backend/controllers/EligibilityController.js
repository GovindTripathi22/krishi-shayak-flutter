const mongoose = require('mongoose');
const Profile = require('../models/Profile');
const EligibilityCheck = require('../models/EligibilityCheck');
const EligibilityService = require('../services/EligibilityService');

const presentScheme = (scheme) => ({ id: scheme._id.toString(), name: scheme.name, shortDescription: scheme.shortDescription, benefits: scheme.benefits, category: scheme.category, officialApplicationLink: scheme.officialApplicationLink, officialWebsite: scheme.officialWebsite, requiredDocuments: scheme.requiredDocuments, isCentralScheme: scheme.isCentralScheme });
const validateDocuments = (documents) => {
  if (documents === undefined) return [];
  if (!Array.isArray(documents) || documents.length > 50 || documents.some((doc) => typeof doc !== 'string' || !doc.trim() || doc.length > 200)) { const error = new Error('documents must be an array of up to 50 document names.'); error.statusCode = 400; throw error; }
  return documents.map((doc) => doc.trim());
};
const profileFromRequest = (storedProfile, requestedProfile) => {
  const profile = { ...(storedProfile || {}), ...(requestedProfile || {}) };
  const requiredText = ['state', 'district', 'category', 'gender', 'farmerType', 'irrigationType'];
  if (requiredText.some((key) => typeof profile[key] !== 'string' || !profile[key].trim())) { const error = new Error('A complete profile with state, district, category, gender, farmer type, and irrigation type is required.'); error.statusCode = 400; throw error; }
  if (!Array.isArray(profile.cropType) || !profile.cropType.length || profile.cropType.some((crop) => typeof crop !== 'string' || !crop.trim())) { const error = new Error('profile.cropType must contain at least one crop.'); error.statusCode = 400; throw error; }
  for (const key of ['age', 'annualIncome', 'landSize']) if (!Number.isFinite(Number(profile[key])) || Number(profile[key]) < 0) { const error = new Error(`profile.${key} must be a valid non-negative number.`); error.statusCode = 400; throw error; }
  if (Number(profile.age) > 120) { const error = new Error('profile.age cannot exceed 120.'); error.statusCode = 400; throw error; }
  return { ...profile, age: Number(profile.age), annualIncome: Number(profile.annualIncome), landSize: Number(profile.landSize), cropType: profile.cropType.map((crop) => crop.trim()) };
};

class EligibilityController {
  static async checkEligibility(req, res, next) {
    try {
      const documents = validateDocuments(req.body.documents);
      const { schemeId } = req.body;
      if (schemeId && !mongoose.isValidObjectId(schemeId)) return res.status(400).json({ success: false, message: 'Invalid schemeId.' });
      const storedProfile = await Profile.findOne({ userId: req.user.id }).lean();
      const profile = profileFromRequest(storedProfile, req.body.profile);
      const results = await EligibilityService.evaluateEligibility({ userId: req.user.id, profile, documents, schemeId });
      res.json({ success: true, data: results.map((result) => ({ scheme: presentScheme(result.scheme), status: result.status, matchPercentage: result.matchPercentage, missingCriteria: result.missingCriteria, missingDocuments: result.missingDocuments, reasons: result.reasons, suggestions: result.suggestions })) });
    } catch (error) { next(error); }
  }
  static async history(req, res, next) {
    try {
      const page = Math.max(1, Number.parseInt(req.query.page || '1', 10)); const limit = Math.min(50, Math.max(1, Number.parseInt(req.query.limit || '20', 10)));
      const [total, checks] = await Promise.all([EligibilityCheck.countDocuments({ userId: req.user.id }), EligibilityCheck.find({ userId: req.user.id }).populate('schemeId', 'name').sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit).lean()]);
      res.json({ success: true, data: checks.map((check) => ({ id: check._id, schemeId: check.schemeId?._id, schemeName: check.schemeId?.name, status: check.status, matchPercentage: check.matchPercentage, missingCriteria: check.missingCriteria, missingDocuments: check.missingDocuments, reasons: check.reasons, suggestions: check.suggestions, createdAt: check.createdAt })), pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error) { next(error); }
  }
}
module.exports = EligibilityController;
