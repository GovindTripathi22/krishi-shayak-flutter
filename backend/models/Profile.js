const mongoose = require('mongoose');

const ProfileSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
      index: true,
    },
    fullName: {
      type: String,
      required: true,
      trim: true,
    },
    state: {
      type: String,
      required: true,
      index: true,
    },
    district: {
      type: String,
      required: true,
      index: true,
    },
    taluka: {
      type: String,
      trim: true,
    },
    landSizeAcres: {
      type: Number,
      required: true,
      min: 0,
    },
    primaryCrops: [
      {
        type: String,
        trim: true,
      },
    ],
    farmerCategory: {
      type: String,
      enum: ['Small Farmer', 'Marginal Farmer', 'Large Farmer', 'Tenant Farmer'],
      default: 'Small Farmer',
    },
    annualIncome: {
      type: Number,
    },
    preferredLanguage: {
      type: String,
      default: 'en',
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Profile', ProfileSchema);
