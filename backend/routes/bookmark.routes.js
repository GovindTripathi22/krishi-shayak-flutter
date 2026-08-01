const express = require('express');
const router = express.Router();
const BookmarkController = require('../controllers/BookmarkController');

router.get('/', BookmarkController.getBookmarks);
router.post('/toggle', BookmarkController.toggleBookmark);

module.exports = router;
