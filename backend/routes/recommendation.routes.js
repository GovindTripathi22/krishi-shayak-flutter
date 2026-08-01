const express = require('express');
const router = express.Router();
const RecommendationController = require('../controllers/RecommendationController');
const { protect } = require('../middleware/auth.middleware');

router.use(protect);
router.get('/', RecommendationController.getRecommendations);
router.get('/top', RecommendationController.top);
router.get('/history', RecommendationController.history);
router.post('/refresh', RecommendationController.refresh);

module.exports = router;
