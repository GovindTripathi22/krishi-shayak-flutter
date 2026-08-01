const mongoose = require('mongoose');

const RecommendationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    recommendedSchemeIds: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'GovernmentScheme',
      },
    ],
    matchConfidencePercentage: {
      type: Number,
      default: 0,
    },
    reasoningBullets: [
      {
        type: String,
      },
    ],
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Recommendation', RecommendationSchema);
