const { body } = require('express-validator');

const profileValidation = [
  body('fullName').notEmpty().withMessage('Full Name is required.').trim(),
  body('state').notEmpty().withMessage('State is required.').trim(),
  body('district').notEmpty().withMessage('District is required.').trim(),
  body('landSize').isNumeric().withMessage('Land size must be a number in acres.'),
  body('age').optional().isInt({ min: 18, max: 120 }).withMessage('Age must be between 18 and 120.'),
];

module.exports = {
  profileValidation,
};
