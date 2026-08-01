const mongoose = require('mongoose');

const EligibilityRuleSchema = new mongoose.Schema(
  {
    schemeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'GovernmentScheme',
      required: true,
      index: true,
    },
    maxLandSizeAcres: {
      type: Number,
    },
    minLandSizeAcres: {
      type: Number,
    },
    maxIncome: {
      type: Number,
    },
    allowedCategories: [
      {
        type: String,
      },
    ],
    requiredDocumentsList: [
      {
        type: String,
      },
    ],
    ruleExpression: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('EligibilityRule', EligibilityRuleSchema);
