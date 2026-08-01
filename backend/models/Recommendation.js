const mongoose = require('mongoose');

const RecommendationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    profileSnapshot: { type: mongoose.Schema.Types.Mixed, required: true },
    policyVersion: { type: Number, required: true },
    recommendations: [{
      schemeId: { type: mongoose.Schema.Types.ObjectId, ref: 'GovernmentScheme', required: true },
      matchPercentage: { type: Number, required: true, min: 0, max: 100 },
      eligibilityStatus: { type: String, enum: ['Eligible', 'Partially Eligible', 'Not Eligible'], required: true },
      score: { type: Number, required: true },
      reasons: { type: [String], default: [] },
      missingDocuments: { type: [String], default: [] },
    }],
  },
  {
    timestamps: true,
  }
);

RecommendationSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('Recommendation', RecommendationSchema);
