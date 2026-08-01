const mongoose = require('mongoose');
const GovernmentScheme = require('../models/GovernmentScheme');
const { isConnected } = require('../config/database');
const seedSchemes = require('../seeds/governmentSchemes');

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
  id: scheme._id ? scheme._id.toString() : (scheme.schemeCode || 'scheme_1'),
  schemeCode: scheme.schemeCode || '',
  name: scheme.name,
  shortDescription: scheme.shortDescription,
  detailedDescription: scheme.detailedDescription,
  benefits: scheme.benefits,
  financialAssistance: scheme.financialAssistance,
  eligibilityCriteria: scheme.eligibilityCriteria || [],
  requiredDocuments: scheme.requiredDocuments || [],
  deadline: scheme.deadlineLabel || (scheme.applicationDeadline ? new Date(scheme.applicationDeadline).toISOString().slice(0, 10) : ''),
  applicationDeadline: scheme.applicationDeadline,
  startDate: scheme.startDate || '',
  endDate: scheme.endDate || '',
  officialWebsite: scheme.officialWebsite || '',
  officialApplicationLink: scheme.officialApplicationLink || '',
  category: scheme.category || 'General',
  isCentralScheme: scheme.isCentralScheme !== false,
  applicableStates: scheme.applicableStates || ['All India'],
  applicableDistricts: scheme.applicableDistricts || ['All Districts'],
  applicableCrops: scheme.applicableCrops || ['All Crops'],
  landRequirement: scheme.landRequirement || '',
  incomeRequirement: scheme.incomeRequirement || '',
  farmerCategory: scheme.farmerCategory || '',
  importantNotes: scheme.importantNotes || [],
  faqs: scheme.faqs || [],
  isFeatured: scheme.isFeatured !== false,
  priorityScore: scheme.priorityScore || 80,
  status: scheme.status || 'Active',
  isBookmarked: bookmarked,
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
    return filter;
  }

  static async list(req, res, next) {
    try {
      const { page, limit } = pagination(req.query);
      const filter = SchemeController.buildFilter(req.query);
      const sortKey = req.query.sort || 'newest';
      if (!SORTS[sortKey]) { const e = new Error('Invalid sort option.'); e.statusCode = 400; throw e; }

      if (isConnected()) {
        const [total, schemes] = await Promise.all([
          GovernmentScheme.countDocuments(filter),
          GovernmentScheme.find(filter).sort(SORTS[sortKey]).skip((page - 1) * limit).limit(limit).lean()
        ]);
        if (page > 1 && schemes.length === 0 && total > 0) return res.status(404).json({ success: false, message: 'Requested page is out of range.' });
        return res.json({
          success: true,
          schemes: schemes.map((s) => serialize(s)),
          data: schemes.map((s) => serialize(s)),
          pagination: { page, limit, total, totalPages: Math.ceil(total / limit) }
        });
      }

      // Fallback in-memory seeded schemes when DB is offline
      const formatted = seedSchemes.map((s, idx) => serialize({ ...s, _id: `seed_${idx + 1}` }));
      return res.json({
        success: true,
        schemes: formatted,
        data: formatted,
        pagination: { page: 1, limit: formatted.length, total: formatted.length, totalPages: 1 }
      });
    } catch (error) { next(error); }
  }

  static async search(req, res, next) {
    try {
      const q = req.query.q || req.query.query || '';
      const formatted = seedSchemes.map((s, idx) => serialize({ ...s, _id: `seed_${idx + 1}` }));
      if (!q.trim()) return res.json({ success: true, schemes: formatted, data: formatted });

      const filtered = formatted.filter(s =>
        s.name.toLowerCase().includes(q.toLowerCase()) ||
        s.shortDescription.toLowerCase().includes(q.toLowerCase()) ||
        s.category.toLowerCase().includes(q.toLowerCase())
      );
      return res.json({ success: true, schemes: filtered, data: filtered });
    } catch (error) { next(error); }
  }

  static async getCategories(req, res, next) {
    try {
      const categories = [
        { id: 'financial', name: 'Financial Assistance', icon: 'payments', count: 12 },
        { id: 'insurance', name: 'Crop Insurance', icon: 'security', count: 8 },
        { id: 'irrigation', name: 'Irrigation & Water', icon: 'water_drop', count: 6 },
        { id: 'machinery', name: 'Farm Machinery & SMAM', icon: 'precision_manufacturing', count: 10 },
        { id: 'fertilizer', name: 'Soil & Fertilizer Subsidy', icon: 'eco', count: 7 },
      ];
      return res.json({ success: true, categories, data: categories });
    } catch (error) { next(error); }
  }

  static async featured(req, res, next) {
    try {
      const formatted = seedSchemes.filter(s => s.isFeatured !== false).map((s, idx) => serialize({ ...s, _id: `seed_${idx + 1}` }));
      return res.json({ success: true, schemes: formatted, data: formatted });
    } catch (error) { next(error); }
  }

  static async latest(req, res, next) {
    try {
      const formatted = seedSchemes.map((s, idx) => serialize({ ...s, _id: `seed_${idx + 1}` }));
      return res.json({ success: true, schemes: formatted, data: formatted });
    } catch (error) { next(error); }
  }

  static async getById(req, res, next) {
    try {
      const { id } = req.params;
      if (isConnected() && mongoose.Types.ObjectId.isValid(id)) {
        const scheme = await GovernmentScheme.findById(id).lean();
        if (scheme) return res.json({ success: true, scheme: serialize(scheme), data: serialize(scheme) });
      }

      const found = seedSchemes.find(s => s.schemeCode === id || s.name === id) || seedSchemes[0];
      return res.json({ success: true, scheme: serialize(found), data: serialize(found) });
    } catch (error) { next(error); }
  }
}

module.exports = SchemeController;
