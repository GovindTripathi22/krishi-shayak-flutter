const { body } = require('express-validator');

const registerValidation = [
  body('phoneNumber').optional().isMobilePhone('en-IN').withMessage('Invalid Indian phone number format.'),
  body('email').optional().isEmail().withMessage('Invalid email address format.'),
  body('password').optional().isLength({ min: 6 }).withMessage('Password must be at least 6 characters long.'),
];

const loginValidation = [
  body('phoneNumber').optional().isMobilePhone('en-IN').withMessage('Invalid Indian phone number.'),
  body('email').optional().isEmail().withMessage('Invalid email address.'),
];

const sendOtpValidation = [
  body('phoneNumber').notEmpty().withMessage('Phone number is required.').isMobilePhone('en-IN').withMessage('Invalid phone number.'),
];

const verifyOtpValidation = [
  body('phoneNumber').notEmpty().withMessage('Phone number is required.'),
  body('otp').notEmpty().withMessage('OTP is required.').isLength({ min: 4, max: 6 }).withMessage('OTP must be 4 to 6 digits.'),
];

module.exports = {
  registerValidation,
  loginValidation,
  sendOtpValidation,
  verifyOtpValidation,
};
