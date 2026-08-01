class EligibilityController {
  static async checkEligibility(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Eligibility checker endpoint will be available in Phase 2.',
    });
  }
}

module.exports = EligibilityController;
