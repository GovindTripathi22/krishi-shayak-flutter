const mongoose = require('mongoose');
const DocumentAnalysisSchema = new mongoose.Schema({
  documentId: { type: mongoose.Schema.Types.ObjectId, ref: 'Document', required: true, unique: true, index: true },
  summary: { type: String, required: true },
  importantPoints: { type: [String], default: [] },
  eligibilityInformation: { type: [String], default: [] },
  requiredDocuments: { type: [String], default: [] },
  schemeReferences: [{ schemeId: { type: mongoose.Schema.Types.ObjectId, ref: 'GovernmentScheme' }, name: String }],
  deadlines: { type: [String], default: [] },
  warnings: { type: [String], default: [] },
  recommendations: { type: [String], default: [] },
  model: { type: String, required: true },
  status: { type: String, enum: ['completed', 'failed'], default: 'completed' },
}, { timestamps: true, collection: 'document_analysis' });
module.exports = mongoose.model('DocumentAnalysis', DocumentAnalysisSchema);
