const express = require('express');
const router = express.Router();
const ChatController = require('../controllers/ChatController');

router.post('/', ChatController.sendMessage);
router.get('/history', ChatController.getChatHistory);

module.exports = router;
