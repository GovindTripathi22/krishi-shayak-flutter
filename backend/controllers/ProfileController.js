const Profile = require('../models/Profile');
const { isConnected } = require('../config/database');

const devProfiles = new Map();

class ProfileController {
  static async getProfile(req, res, next) {
    try {
      if (isConnected()) {
        const profile = await Profile.findOne({ userId: req.user.id });
        if (profile) {
          return res.status(200).json({ success: true, profile });
        }
      }

      if (devProfiles.has(req.user.id)) {
        return res.status(200).json({ success: true, profile: devProfiles.get(req.user.id) });
      }

      const defaultProfile = {
        userId: req.user.id,
        fullName: 'Ramesh Patil',
        gender: 'Male',
        age: 38,
        category: 'Small Farmer',
        state: 'Maharashtra',
        district: 'Nashik',
        landSize: 3.0,
        cropType: ['Cotton', 'Wheat'],
        annualIncome: 120000,
        preferredLanguage: 'en',
      };
      res.status(200).json({ success: true, profile: defaultProfile });
    } catch (err) {
      next(err);
    }
  }

  static async createProfile(req, res, next) {
    try {
      if (isConnected()) {
        const profile = await Profile.create({ userId: req.user.id, ...req.body });
        return res.status(201).json({ success: true, profile });
      }

      const newProfile = { userId: req.user.id, ...req.body };
      devProfiles.set(req.user.id, newProfile);
      res.status(201).json({ success: true, profile: newProfile });
    } catch (err) {
      next(err);
    }
  }

  static async updateProfile(req, res, next) {
    try {
      if (isConnected()) {
        const profile = await Profile.findOneAndUpdate({ userId: req.user.id }, req.body, { new: true, upsert: true });
        return res.status(200).json({ success: true, profile });
      }

      const updated = { userId: req.user.id, ...req.body };
      devProfiles.set(req.user.id, updated);
      res.status(200).json({ success: true, profile: updated });
    } catch (err) {
      next(err);
    }
  }

  static async deleteProfile(req, res, next) {
    try {
      if (isConnected()) {
        await Profile.findOneAndDelete({ userId: req.user.id });
      }
      devProfiles.delete(req.user.id);
      res.status(200).json({ success: true, message: 'Profile deleted successfully.' });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = ProfileController;
