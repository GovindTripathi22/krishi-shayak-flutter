const mongoose = require('mongoose');

const EligibilityCheckSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  schemeId: { type: mongoose.Schema.Types.ObjectId, ref: 'GovernmentScheme', required: true, index: true },
  profileSnapshot: { type: mongoose.Schema.Types.Mixed, required: true },
  status: { type: String, enum: ['Eligible', 'Partially Eligible', 'Not Eligible'], required: true, index: true },
  matchPercentage: { type: Number, required: true, min: 0, max: 100 },
  missingCriteria: { type: [String], default: [] },
  missingDocuments: { type: [String], default: [] },
  reasons: { type: [String], default: [] },
  suggestions: { type: [String], default: [] },
}, { timestamps: true, collection: 'eligibility_checks' });

EligibilityCheckSchema.index({ userId: 1, createdAt: -1 });
module.exports = mongoose.model('EligibilityCheck', EligibilityCheckSchema);
