const mongoose = require('mongoose');
const GovernmentScheme = require('../models/GovernmentScheme');

const SORTS = {
  newest: { createdAt: -1 },
  updated: { updatedAt: -1 },
  benefits: { financialAssistanceAmount: -1, priorityScore: -1 },
  deadline: { applicationDeadline: 1, priorityScore: -1 },
  alphabetical: { name: 1 },
  popular: { priorityScore: -1, updatedAt: -1 },
};
const STATUSES = new Set(['Active', 'Inactive', 'Upcoming', 'Closed']);
const safeText = (value, field) => {
  if (typeof value !== 'string' || !value.trim() || value.trim().length > 120) {
    const error = new Error(`${field} must be between 1 and 120 characters.`); error.statusCode = 400; throw error;
  }
  return value.trim();
};
const escapeRegex = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const asBoolean = (value, field) => {
  if (value === undefined) return undefined;
  if (value === 'true' || value === true) return true;
  if (value === 'false' || value === false) return false;
  const error = new Error(`${field} must be true or false.`); error.statusCode = 400; throw error;
};
const pagination = (query) => {
  const page = Number.parseInt(query.page || '1', 10);
  const limit = Number.parseInt(query.limit || '20', 10);
  if (!Number.isInteger(page) || page < 1 || !Number.isInteger(limit) || limit < 1 || limit > 50) {
    const error = new Error('page must be positive and limit must be between 1 and 50.'); error.statusCode = 400; throw error;
  }
  return { page, limit };
};
const serialize = (scheme, bookmarked = false) => ({
  id: scheme._id.toString(), name: scheme.name, shortDescription: scheme.shortDescription,
  detailedDescription: scheme.detailedDescription, benefits: scheme.benefits, financialAssistance: scheme.financialAssistance,
  eligibilityCriteria: scheme.eligibilityCriteria, requiredDocuments: scheme.requiredDocuments,
  deadline: scheme.deadlineLabel || (scheme.applicationDeadline ? scheme.applicationDeadline.toISOString().slice(0, 10) : ''),
  applicationDeadline: scheme.applicationDeadline, startDate: scheme.startDate?.toISOString().slice(0, 10) || '', endDate: scheme.endDate?.toISOString().slice(0, 10) || '',
  officialWebsite: scheme.officialWebsite, officialApplicationLink: scheme.officialApplicationLink,
  category: scheme.category, isCentralScheme: scheme.isCentralScheme, applicableStates: scheme.applicableStates,
  applicableDistricts: scheme.applicableDistricts, applicableCrops: scheme.applicableCrops, landRequirement: scheme.landRequirement,
  incomeRequirement: scheme.incomeRequirement, farmerCategory: scheme.farmerCategory, genderRestrictions: scheme.genderRestrictions,
  ageRequirement: scheme.ageRequirement, importantNotes: scheme.importantNotes, faqs: scheme.faqs,
  languageVersions: scheme.languageVersions instanceof Map ? Object.fromEntries(scheme.languageVersions) : (scheme.languageVersions || {}), isFeatured: scheme.isFeatured,
  priorityScore: scheme.priorityScore, status: scheme.status, createdDate: scheme.createdAt, lastUpdatedDate: scheme.updatedAt, isBookmarked: bookmarked,
});

class SchemeController {
  static buildFilter(query) {
    const filter = {};
    const fields = [['state', 'applicableStates'], ['district', 'applicableDistricts'], ['crop', 'applicableCrops'], ['category', 'category']];
    for (const [param, column] of fields) if (query[param]) filter[column] = new RegExp(`^${escapeRegex(safeText(query[param], param))}$`, 'i');
    let centralValue = query.isCentralScheme;
    if (centralValue === undefined && query.schemeType === 'central') centralValue = true;
    if (centralValue === undefined && query.schemeType === 'state') centralValue = false;
    if (query.schemeType && !['central', 'state'].includes(query.schemeType)) { const e = new Error('schemeType must be central or state.'); e.statusCode = 400; throw e; }
    const central = asBoolean(centralValue, 'schemeType');
    if (central !== undefined) filter.isCentralScheme = central;
    if (query.featured !== undefined) filter.isFeatured = asBoolean(query.featured, 'featured');
    if (query.status) { if (!STATUSES.has(query.status)) { const e = new Error('Invalid status.'); e.statusCode = 400; throw e; } filter.status = query.status; }
    if (query.deadline === 'upcoming') filter.applicationDeadline = { $gte: new Date() };
    else if (query.deadline && query.deadline !== 'all') { const e = new Error('deadline must be upcoming or all.'); e.statusCode = 400; throw e; }
    return filter;
  }
  static async list(req, res, next) {
    try {
      const { page, limit } = pagination(req.query); const filter = SchemeController.buildFilter(req.query);
      const sortKey = req.query.sort || 'newest'; if (!SORTS[sortKey]) { const e = new Error('Invalid sort option.'); e.statusCode = 400; throw e; }
      if (sortKey === 'deadline' && !filter.applicationDeadline) filter.applicationDeadline = { $ne: null };
      const [total, schemes] = await Promise.all([GovernmentScheme.countDocuments(filter), GovernmentScheme.find(filter).sort(SORTS[sortKey]).skip((page - 1) * limit).limit(limit).lean()]);
      if (page > 1 && schemes.length === 0 && total > 0) return res.status(404).json({ success: false, message: 'Requested page is out of range.' });
      res.json({ success: true, data: schemes.map((s) => serialize(s)), pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error) { next(error); }
  }
  static async search(req, res, next) {
    try {
      const term = safeText(req.query.q || req.query.query, 'q'); const { page, limit } = pagination(req.query); const filter = SchemeController.buildFilter(req.query);
      filter.$text = { $search: term };
      const sortKey = req.query.sort || 'popular';
      if (!SORTS[sortKey]) { const e = new Error('Invalid sort option.'); e.statusCode = 400; throw e; }
      if (sortKey === 'deadline' && !filter.applicationDeadline) filter.applicationDeadline = { $ne: null };
      const [total, schemes] = await Promise.all([GovernmentScheme.countDocuments(filter), GovernmentScheme.find(filter).sort(SORTS[sortKey]).skip((page - 1) * limit).limit(limit).lean()]);
      res.json({ success: true, data: schemes.map((s) => serialize(s)), pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error) { next(error); }
  }
  static async getCategories(req, res, next) { try { const categories = await GovernmentScheme.distinct('category', { status: 'Active' }); res.json({ success: true, data: categories.sort() }); } catch (e) { next(e); } }
  static async featured(req, res, next) { req.query.featured = 'true'; req.query.sort = req.query.sort || 'popular'; return SchemeController.list(req, res, next); }
  static async latest(req, res, next) { req.query.sort = 'newest'; return SchemeController.list(req, res, next); }
  static async getById(req, res, next) { try { if (!mongoose.isValidObjectId(req.params.id)) return res.status(400).json({ success: false, message: 'Invalid scheme ID.' }); const scheme = await GovernmentScheme.findById(req.params.id).lean(); if (!scheme) return res.status(404).json({ success: false, message: 'Scheme not found.' }); res.json({ success: true, data: serialize(scheme) }); } catch (e) { next(e); } }
}
module.exports = SchemeController;
