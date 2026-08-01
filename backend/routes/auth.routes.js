const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/AuthController');
const { protect } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/validation.middleware');
const {
  sendOtpValidation,
  verifyOtpValidation,
  registerValidation,
  loginValidation,
} = require('../validators/auth.validator');

router.post('/send-otp', sendOtpValidation, validateRequest, AuthController.sendOtp);
router.post('/verify-otp', verifyOtpValidation, validateRequest, AuthController.verifyOtp);
router.post('/google', AuthController.googleAuth);
router.post('/register', registerValidation, validateRequest, AuthController.register);
router.post('/login', loginValidation, validateRequest, AuthController.login);
router.post('/refresh', AuthController.refreshToken);
router.post('/logout', protect, AuthController.logout);
router.get('/me', protect, AuthController.getMe);
router.delete('/account', protect, AuthController.deleteAccount);

module.exports = router;
