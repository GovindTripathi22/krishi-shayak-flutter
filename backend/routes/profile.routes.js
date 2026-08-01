const express = require('express');
const router = express.Router();
const ProfileController = require('../controllers/ProfileController');
const { protect } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/validation.middleware');
const { profileValidation } = require('../validators/profile.validator');

router.use(protect);

router.get('/', ProfileController.getProfile);
router.post('/', profileValidation, validateRequest, ProfileController.createProfile);
router.put('/', profileValidation, validateRequest, ProfileController.updateProfile);
router.delete('/', ProfileController.deleteProfile);

module.exports = router;
