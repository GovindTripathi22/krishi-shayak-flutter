const mongoose = require('mongoose');

const GovernmentSchemeSchema = new mongoose.Schema(
  {
    schemeCode: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      index: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    shortDescription: {
      type: String,
      required: true,
    },
    detailedDescription: {
      type: String,
    },
    benefits: {
      type: String,
      required: true,
    },
    financialAssistanceAmount: {
      type: Number,
      default: 0,
    },
    category: {
      type: String,
      required: true,
      index: true,
    },
    isCentralScheme: {
      type: Boolean,
      default: true,
    },
    applicableStates: [
      {
        type: String,
        index: true,
      },
    ],
    applicableCrops: [
      {
        type: String,
      },
    ],
    officialApplicationLink: {
      type: String,
      required: true,
    },
    officialWebsite: {
      type: String,
    },
    applicationDeadline: {
      type: Date,
    },
    status: {
      type: String,
      enum: ['Active', 'Inactive', 'Upcoming', 'Closed'],
      default: 'Active',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('GovernmentScheme', GovernmentSchemeSchema);
