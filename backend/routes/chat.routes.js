const express = require('express');
const ChatController = require('../controllers/ChatController');
const { protect } = require('../middleware/auth.middleware');
const { aiLimiter } = require('../middleware/rate_limiter.middleware');

const router = express.Router();

router.use(protect, aiLimiter);

router.post('/', ChatController.sendMessage);
router.post('/stream', ChatController.sendMessage);
router.get('/history', ChatController.history);
router.post('/history', ChatController.history);
router.delete('/history', ChatController.deleteHistory);
router.get('/suggestions', ChatController.getSuggestions);

module.exports = router;
