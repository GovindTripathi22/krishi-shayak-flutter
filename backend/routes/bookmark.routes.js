const express = require('express');
const BookmarkController = require('../controllers/BookmarkController');
const { protect } = require('../middleware/auth.middleware');
const router = express.Router();
router.use(protect);
router.get('/', BookmarkController.getBookmarks);
router.post('/', BookmarkController.addBookmark);
router.delete('/:id', BookmarkController.removeBookmark);
module.exports = router;
