const express = require('express');
const router = express.Router();
const EligibilityController = require('../controllers/EligibilityController');

router.post('/check', EligibilityController.checkEligibility);

module.exports = router;
