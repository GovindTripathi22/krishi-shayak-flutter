const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const UserSchema = new mongoose.Schema(
  {
    phoneNumber: {
      type: String,
      unique: true,
      sparse: true,
      trim: true,
      index: true,
    },
    email: {
      type: String,
      unique: true,
      sparse: true,
      trim: true,
      lowercase: true,
      index: true,
    },
    password: {
      type: String,
      select: false,
    },
    authProvider: {
      type: String,
      enum: ['phone', 'google'],
      default: 'phone',
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    role: {
      type: String,
      enum: ['farmer', 'admin', 'officer'],
      default: 'farmer',
    },
    status: {
      type: String,
      enum: ['active', 'suspended'],
      default: 'active',
    },
    refreshToken: {
      type: String,
      select: false,
    },
    lastLoginAt: {
      type: Date,
    },
  },
  {
    timestamps: true,
  }
);

// Hash password before saving if modified
UserSchema.pre('save', async function (next) {
  if (!this.isModified('password') || !this.password) {
    return next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Instance method to compare password
UserSchema.methods.matchPassword = async function (enteredPassword) {
  if (!this.password) return false;
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = mongoose.model('User', UserSchema);
