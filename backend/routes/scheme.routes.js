const express = require('express');
const router = express.Router();
const SchemeController = require('../controllers/SchemeController');

router.get('/', SchemeController.getAllSchemes);
router.get('/:id', SchemeController.getSchemeById);

module.exports = router;
