const express = require('express');
const router = express.Router();
const ChecklistController = require('../controllers/ChecklistController');

router.get('/:schemeId', ChecklistController.getChecklistByScheme);
router.post('/status', ChecklistController.updateChecklistStatus);

module.exports = router;
