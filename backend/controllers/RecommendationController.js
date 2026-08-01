const Profile = require('../models/Profile');
const Recommendation = require('../models/Recommendation');
const RecommendationService = require('../services/RecommendationService');

const presentScheme = (scheme) => ({ id: scheme._id.toString(), name: scheme.name, shortDescription: scheme.shortDescription, benefits: scheme.benefits, category: scheme.category, officialApplicationLink: scheme.officialApplicationLink, officialWebsite: scheme.officialWebsite, requiredDocuments: scheme.requiredDocuments, isFeatured: scheme.isFeatured });
const presentHistory = (history) => history.recommendations.filter((item) => item.schemeId).map((item) => ({ scheme: presentScheme(item.schemeId), matchPercentage: item.matchPercentage, recommendationScore: item.score, eligibilityStatus: item.eligibilityStatus, whyRecommended: item.reasons, missingDocuments: item.missingDocuments }));
const paging = (query) => {
  const page = Number.parseInt(query.page || '1', 10); const limit = Number.parseInt(query.limit || '20', 10);
  if (!Number.isInteger(page) || page < 1 || !Number.isInteger(limit) || limit < 1 || limit > 50) { const error = new Error('page must be positive and limit must be between 1 and 50.'); error.statusCode = 400; throw error; }
  return { page, limit };
};
const documents = (value) => {
  if (value === undefined) return [];
  if (!Array.isArray(value) || value.some((item) => typeof item !== 'string' || !item.trim() || item.length > 200)) { const error = new Error('documents must be an array of document names.'); error.statusCode = 400; throw error; }
  return value.map((item) => item.trim());
};
const requestProfile = (storedProfile, requestedProfile) => {
  const profile = { ...(storedProfile || {}), ...(requestedProfile || {}) };
  if (!profile.state || !profile.district || !profile.category || !profile.gender || !profile.farmerType || !profile.irrigationType || !Array.isArray(profile.cropType) || !profile.cropType.length) { const error = new Error('A complete farmer profile is required.'); error.statusCode = 400; throw error; }
  for (const key of ['age', 'annualIncome', 'landSize']) if (!Number.isFinite(Number(profile[key])) || Number(profile[key]) < 0) { const error = new Error(`profile.${key} must be a valid non-negative number.`); error.statusCode = 400; throw error; }
  return { ...profile, age: Number(profile.age), annualIncome: Number(profile.annualIncome), landSize: Number(profile.landSize) };
};

class RecommendationController {
  static async getRecommendations(req, res, next) {
    try {
      const { page, limit } = paging(req.query);
      const latest = await Recommendation.findOne({ userId: req.user.id }).sort({ createdAt: -1 }).populate('recommendations.schemeId').lean();
      if (!latest) return res.json({ success: true, data: [], pagination: { page, limit, total: 0, totalPages: 0 } });
      let data = presentHistory(latest);
      if (req.query.status) data = data.filter((item) => item.eligibilityStatus === req.query.status);
      if (req.query.sort === 'match') data.sort((a, b) => b.matchPercentage - a.matchPercentage);
      else if (!req.query.sort || req.query.sort === 'score') data.sort((a, b) => b.recommendationScore - a.recommendationScore);
      else { const error = new Error('sort must be score or match.'); error.statusCode = 400; throw error; }
      const total = data.length;
      res.json({ success: true, data: data.slice((page - 1) * limit, page * limit), generatedAt: latest.createdAt, policyVersion: latest.policyVersion, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error) { next(error); }
  }
  static async top(req, res, next) { req.query.page = '1'; req.query.limit = String(Math.min(10, Number.parseInt(req.query.limit || '5', 10))); return RecommendationController.getRecommendations(req, res, next); }
  static async history(req, res, next) {
    try {
      const { page, limit } = paging(req.query);
      const [total, history] = await Promise.all([Recommendation.countDocuments({ userId: req.user.id }), Recommendation.find({ userId: req.user.id }).sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit).lean()]);
      res.json({ success: true, data: history.map((item) => ({ id: item._id, createdAt: item.createdAt, policyVersion: item.policyVersion, recommendationCount: item.recommendations.length, topMatchPercentage: Math.max(0, ...item.recommendations.map((entry) => entry.matchPercentage)) })), pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error) { next(error); }
  }
  static async refresh(req, res, next) {
    try {
      const storedProfile = await Profile.findOne({ userId: req.user.id }).lean();
      const profile = requestProfile(storedProfile, req.body.profile);
      const result = await RecommendationService.generateRecommendationsForFarmer({ userId: req.user.id, profile, documents: documents(req.body.documents) });
      res.status(201).json({ success: true, data: result.ranked.map((item) => ({ scheme: presentScheme(item.scheme), matchPercentage: item.eligibility.matchPercentage, recommendationScore: item.score, eligibilityStatus: item.eligibility.status, whyRecommended: item.reasons, missingDocuments: item.eligibility.missingDocuments })), generatedAt: result.history.createdAt, policyVersion: result.history.policyVersion });
    } catch (error) { next(error); }
  }
}
module.exports = RecommendationController;
