const mongoose = require('mongoose');
const Bookmark = require('../models/Bookmark');
const GovernmentScheme = require('../models/GovernmentScheme');

const present = (scheme, bookmark) => ({
  id: scheme._id.toString(), name: scheme.name, shortDescription: scheme.shortDescription, detailedDescription: scheme.detailedDescription,
  benefits: scheme.benefits, financialAssistance: scheme.financialAssistance, eligibilityCriteria: scheme.eligibilityCriteria,
  requiredDocuments: scheme.requiredDocuments, deadline: scheme.deadlineLabel || (scheme.applicationDeadline ? scheme.applicationDeadline.toISOString().slice(0, 10) : ''),
  startDate: scheme.startDate?.toISOString().slice(0, 10) || '', endDate: scheme.endDate?.toISOString().slice(0, 10) || '',
  officialWebsite: scheme.officialWebsite, officialApplicationLink: scheme.officialApplicationLink, category: scheme.category,
  isCentralScheme: scheme.isCentralScheme, applicableStates: scheme.applicableStates, applicableDistricts: scheme.applicableDistricts,
  applicableCrops: scheme.applicableCrops, landRequirement: scheme.landRequirement, incomeRequirement: scheme.incomeRequirement,
  farmerCategory: scheme.farmerCategory, genderRestrictions: scheme.genderRestrictions, ageRequirement: scheme.ageRequirement,
  importantNotes: scheme.importantNotes, faqs: scheme.faqs, languageVersions: scheme.languageVersions instanceof Map ? Object.fromEntries(scheme.languageVersions) : (scheme.languageVersions || {}),
  isFeatured: scheme.isFeatured, priorityScore: scheme.priorityScore, status: scheme.status, createdDate: scheme.createdAt,
  lastUpdatedDate: scheme.updatedAt, isBookmarked: true, bookmarkedAt: bookmark.createdAt,
});

class BookmarkController {
  static async getBookmarks(req, res, next) {
    try {
      const bookmarks = await Bookmark.find({ userId: req.user.id }).sort({ createdAt: -1 }).populate('schemeId').lean();
      res.json({ success: true, data: bookmarks.filter((item) => item.schemeId).map((item) => present(item.schemeId, item)) });
    } catch (error) { next(error); }
  }
  static async addBookmark(req, res, next) {
    try {
      const { schemeId } = req.body;
      if (!mongoose.isValidObjectId(schemeId)) return res.status(400).json({ success: false, message: 'A valid schemeId is required.' });
      const exists = await GovernmentScheme.exists({ _id: schemeId });
      if (!exists) return res.status(404).json({ success: false, message: 'Scheme not found.' });
      const bookmark = await Bookmark.findOneAndUpdate({ userId: req.user.id, schemeId }, {}, { new: true, upsert: true, setDefaultsOnInsert: true });
      res.status(201).json({ success: true, data: { id: bookmark._id, schemeId: bookmark.schemeId, createdAt: bookmark.createdAt } });
    } catch (error) { next(error); }
  }
  static async removeBookmark(req, res, next) {
    try {
      const schemeId = req.params.id;
      if (!mongoose.isValidObjectId(schemeId)) return res.status(400).json({ success: false, message: 'Invalid scheme ID.' });
      const result = await Bookmark.deleteOne({ userId: req.user.id, schemeId });
      if (!result.deletedCount) return res.status(404).json({ success: false, message: 'Bookmark not found.' });
      res.status(204).send();
    } catch (error) { next(error); }
  }
}
module.exports = BookmarkController;
