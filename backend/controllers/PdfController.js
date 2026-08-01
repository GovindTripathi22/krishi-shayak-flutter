class PdfController {
  static async uploadAndExplainPdf(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. PDF OCR & explainer endpoint will be available in Phase 2.',
    });
  }
}

module.exports = PdfController;
