const AuthService = require('../services/AuthService');
const User = require('../models/User');

class AuthController {
  static async sendOtp(req, res, next) {
    try {
      const { phoneNumber } = req.body;
      const result = await AuthService.sendOtp(phoneNumber);
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  }

  static async verifyOtp(req, res, next) {
    try {
      const { phoneNumber, otp } = req.body;
      const result = await AuthService.verifyOtpAndAuth(phoneNumber, otp);
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  }

  static async googleAuth(req, res, next) {
    try {
      const { email, fullName, googleToken } = req.body;
      const result = await AuthService.googleAuth(email, fullName, googleToken);
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  }

  static async register(req, res, next) {
    try {
      const { phoneNumber, email, password } = req.body;
      let user = await User.findOne({ $or: [{ phoneNumber }, { email }] });
      if (user) {
        return res.status(400).json({ success: false, message: 'User already exists.' });
      }
      user = await User.create({ phoneNumber, email, password, isVerified: true });
      const tokens = AuthService.generateTokens(user._id);
      res.status(201).json({ success: true, user: { id: user._id, phoneNumber, email }, tokens });
    } catch (err) {
      next(err);
    }
  }

  static async login(req, res, next) {
    try {
      const { phoneNumber, email, password } = req.body;
      const user = await User.findOne({ $or: [{ phoneNumber }, { email }] }).select('+password');
      if (!user || !(await user.matchPassword(password))) {
        return res.status(401).json({ success: false, message: 'Invalid credentials.' });
      }
      const tokens = AuthService.generateTokens(user._id);
      res.status(200).json({ success: true, user: { id: user._id, phoneNumber: user.phoneNumber, email: user.email }, tokens });
    } catch (err) {
      next(err);
    }
  }

  static async logout(req, res, next) {
    try {
      if (req.user) {
        await User.findByIdAndUpdate(req.user.id, { refreshToken: null });
      }
      res.status(200).json({ success: true, message: 'Logged out successfully.' });
    } catch (err) {
      next(err);
    }
  }

  static async refreshToken(req, res, next) {
    try {
      const { refreshToken } = req.body;
      const tokens = await AuthService.refreshAccessToken(refreshToken);
      res.status(200).json({ success: true, tokens });
    } catch (err) {
      res.status(401).json({ success: false, message: err.message });
    }
  }

  static async getMe(req, res, next) {
    try {
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ success: false, message: 'User not found.' });
      }
      res.status(200).json({ success: true, user });
    } catch (err) {
      next(err);
    }
  }

  static async deleteAccount(req, res, next) {
    try {
      await User.findByIdAndDelete(req.user.id);
      res.status(200).json({ success: true, message: 'Account deleted successfully.' });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = AuthController;
