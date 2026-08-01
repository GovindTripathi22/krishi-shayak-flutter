const mongoose = require('mongoose');
const GovernmentScheme = require('../models/GovernmentScheme');
const Document = require('../models/Document');
const ChecklistHistory = require('../models/ChecklistHistory');

const normalise = (value) => String(value || '').toLowerCase().replace(/[^a-z0-9]/g, '');
class ChecklistController {
  static async getChecklistByScheme(req, res, next) {
    try {
      if (!mongoose.isValidObjectId(req.params.schemeId)) return res.status(400).json({ success: false, message: 'Invalid scheme ID.' });
      const [scheme, documents, saved] = await Promise.all([GovernmentScheme.findById(req.params.schemeId).lean(), Document.find({ userId: req.user.id, processingStatus: 'completed' }).select('fileName').lean(), ChecklistHistory.findOne({ userId: req.user.id, schemeId: req.params.schemeId }).lean()]);
      if (!scheme) return res.status(404).json({ success: false, message: 'Scheme not found.' });
      const uploaded = documents.map((document) => document.fileName); const completed = new Set(saved?.completedItemIds || []);
      const items = scheme.requiredDocuments.map((name, index) => { const id = `required_${index}`; const detected = uploaded.some((fileName) => normalise(fileName).includes(normalise(name)) || normalise(name).includes(normalise(fileName.split('.')[0] || ''))); const isComplete = completed.has(id) || detected; return { id, name, isComplete, source: detected ? 'Matched uploaded document' : 'Required by official scheme record', explanation: detected ? 'A processed upload appears to match this requirement.' : 'Upload or mark this document once it is available.' }; });
      const progressPercentage = items.length ? Math.round(items.filter((item) => item.isComplete).length / items.length * 100) : 0;
      res.json({ success: true, data: { schemeId: scheme._id, schemeName: scheme.name, items, availableDocuments: uploaded, missingDocuments: items.filter((item) => !item.isComplete).map((item) => item.name), progressPercentage } });
    } catch (error) { next(error); }
  }
  static async updateChecklistStatus(req, res, next) {
    try {
      const { schemeId, completedItemIds } = req.body;
      if (!mongoose.isValidObjectId(schemeId) || !Array.isArray(completedItemIds) || completedItemIds.some((id) => typeof id !== 'string' || id.length > 100)) return res.status(400).json({ success: false, message: 'Invalid checklist update.' });
      const scheme = await GovernmentScheme.findById(schemeId).select('requiredDocuments').lean(); if (!scheme) return res.status(404).json({ success: false, message: 'Scheme not found.' });
      const validIds = new Set(scheme.requiredDocuments.map((_, index) => `required_${index}`)); const validCompleted = completedItemIds.filter((id) => validIds.has(id)); const progressPercentage = scheme.requiredDocuments.length ? Math.round(validCompleted.length / scheme.requiredDocuments.length * 100) : 0;
      await ChecklistHistory.findOneAndUpdate({ userId: req.user.id, schemeId }, { $set: { completedItemIds: validCompleted, progressPercentage } }, { upsert: true, new: true });
      res.json({ success: true, data: { progressPercentage, completedItemIds: validCompleted } });
    } catch (error) { next(error); }
  }
}
module.exports = ChecklistController;
