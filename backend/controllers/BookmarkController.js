class BookmarkController {
  static async getBookmarks(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Bookmarks endpoint will be available in Phase 2.',
    });
  }

  static async toggleBookmark(req, res) {
    res.status(501).json({
      success: false,
      message: 'Not Implemented Yet. Toggle bookmark endpoint will be available in Phase 2.',
    });
  }
}

module.exports = BookmarkController;
