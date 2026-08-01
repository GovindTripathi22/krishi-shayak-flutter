const mongoose = require('mongoose');

const EligibilityRuleSchema = new mongoose.Schema(
  {
    schemeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'GovernmentScheme',
      required: true,
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
    allowedFarmerTypes: [{ type: String, trim: true }],
    allowedGenders: [{ type: String, trim: true }],
    allowedIrrigationTypes: [{ type: String, trim: true }],
    applicableStates: [{ type: String, trim: true }],
    applicableDistricts: [{ type: String, trim: true }],
    applicableVillages: [{ type: String, trim: true }],
    applicableCrops: [{ type: String, trim: true }],
    minAge: { type: Number, min: 0, max: 120 },
    maxAge: { type: Number, min: 0, max: 120 },
    requiredDocumentsList: [
      {
        type: String,
      },
    ],
    ruleExpression: {
      type: String,
    },
    // Configurable per-criterion weights; managed by approved admin/import tooling.
    criterionWeights: { type: Map, of: Number, default: {} },
  },
  {
    timestamps: true,
  }
);

EligibilityRuleSchema.index({ schemeId: 1 }, { unique: true });

module.exports = mongoose.model('EligibilityRule', EligibilityRuleSchema);
