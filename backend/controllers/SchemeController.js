class SchemeController {
  static async getAllSchemes(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Schemes repository list endpoint will be available in Phase 2.',
    });
  }

  static async getSchemeById(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Scheme detail endpoint will be available in Phase 2.',
    });
  }
}

module.exports = SchemeController;
