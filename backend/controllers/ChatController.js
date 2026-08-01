class ChatController {
  static async sendMessage(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Gemini AI chat endpoint will be available in Phase 2.',
    });
  }

  static async getChatHistory(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Chat history endpoint will be available in Phase 2.',
    });
  }
}

module.exports = ChatController;
