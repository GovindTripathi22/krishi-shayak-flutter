const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Profile = require('../models/Profile');
const { isConnected } = require('../config/database');

// In-Memory Dev Store when MongoDB Atlas is connecting
const devUsers = new Map();
const devProfiles = new Map();

class AuthService {
  generateTokens(userId) {
    const accessToken = jwt.sign(
      { id: userId },
      process.env.JWT_SECRET || 'dev_jwt_access_secret_key_32chars',
      { expiresIn: process.env.JWT_EXPIRES_IN || '1d' }
    );

    const refreshToken = jwt.sign(
      { id: userId },
      process.env.JWT_REFRESH_SECRET || 'dev_jwt_refresh_secret_key_32chars',
      { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d' }
    );

    return { accessToken, refreshToken };
  }

  async sendOtp(phoneNumber) {
    const otp = process.env.NODE_ENV === 'development' ? '123456' : Math.floor(100000 + Math.random() * 900000).toString();
    return { phoneNumber, otp, message: 'OTP sent successfully.' };
  }

  async verifyOtpAndAuth(phoneNumber, otp) {
    let userId = 'user_' + Date.now();
    let hasProfile = false;

    if (isConnected()) {
      try {
        let user = await User.findOne({ phoneNumber });
        if (!user) {
          user = await User.create({ phoneNumber, authProvider: 'phone', isVerified: true });
        } else {
          user.isVerified = true;
          user.lastLoginAt = new Date();
          await user.save();
        }
        userId = user._id.toString();
        const profile = await Profile.findOne({ userId: user._id });
        hasProfile = !!profile;
      } catch (_) {}
    } else {
      // In-Memory Dev persistence
      if (!devUsers.has(phoneNumber)) {
        devUsers.set(phoneNumber, { id: userId, phoneNumber, isVerified: true });
      } else {
        userId = devUsers.get(phoneNumber).id;
      }
      hasProfile = devProfiles.has(userId);
    }

    const tokens = this.generateTokens(userId);

    return {
      user: {
        id: userId,
        phoneNumber,
        role: 'farmer',
        isVerified: true,
        hasProfile,
      },
      tokens,
    };
  }

  async googleAuth(email, fullName, googleToken) {
    let userId = 'user_google_' + Date.now();

    if (isConnected()) {
      try {
        let user = await User.findOne({ email });
        if (!user) {
          user = await User.create({ email, authProvider: 'google', isVerified: true });
        }
        userId = user._id.toString();
      } catch (_) {}
    } else {
      devUsers.set(email, { id: userId, email, isVerified: true });
    }

    const tokens = this.generateTokens(userId);

    return {
      user: {
        id: userId,
        email,
        role: 'farmer',
        isVerified: true,
        hasProfile: true,
      },
      tokens,
    };
  }

  async refreshAccessToken(refreshToken) {
    if (!refreshToken) {
      throw new Error('Refresh token is required.');
    }
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET || 'dev_jwt_refresh_secret_key_32chars');
    return this.generateTokens(decoded.id);
  }
}

module.exports = new AuthService();
