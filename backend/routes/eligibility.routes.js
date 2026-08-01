const express = require('express');
const router = express.Router();
const EligibilityController = require('../controllers/EligibilityController');
const { protect } = require('../middleware/auth.middleware');

router.use(protect);
router.post('/check', EligibilityController.checkEligibility);
router.get('/history', EligibilityController.history);

module.exports = router;
