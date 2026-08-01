class ProfileController {
  static async getProfile(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Profile retrieval endpoint will be available in Phase 2.',
    });
  }

  static async updateProfile(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Profile update endpoint will be available in Phase 2.',
    });
  }
}

module.exports = ProfileController;
