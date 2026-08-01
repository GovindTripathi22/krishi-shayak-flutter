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
    gender: {
      type: String,
      enum: ['Male', 'Female', 'Other'],
      default: 'Male',
    },
    age: {
      type: Number,
      min: 18,
      max: 120,
    },
    category: {
      type: String,
      enum: ['Small Farmer', 'Marginal Farmer', 'Large Farmer', 'Tenant Farmer'],
      default: 'Small Farmer',
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
    village: {
      type: String,
      trim: true,
    },
    preferredLanguage: {
      type: String,
      default: 'en',
    },
    cropType: [
      {
        type: String,
        trim: true,
      },
    ],
    landSize: {
      type: Number,
      required: true,
      min: 0,
    },
    annualIncome: {
      type: Number,
      min: 0,
    },
    farmerType: {
      type: String,
      enum: ['Owner', 'Tenant', 'Sharecropper'],
      default: 'Owner',
    },
    irrigationType: {
      type: String,
      enum: ['Drip', 'Sprinkler', 'Rainfed', 'Canal', 'Borewell'],
      default: 'Rainfed',
    },
    profileImage: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Profile', ProfileSchema);
