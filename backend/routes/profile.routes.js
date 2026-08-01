const express = require('express');
const router = express.Router();
const ProfileController = require('../controllers/ProfileController');

router.get('/', ProfileController.getProfile);
router.put('/', ProfileController.updateProfile);

module.exports = router;
