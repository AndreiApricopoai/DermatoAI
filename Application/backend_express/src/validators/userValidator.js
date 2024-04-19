const Joi = require('joi');

const registerValidationSchema = Joi.object({
  firstName: Joi.string().required().min(2).max(50),
  lastName: Joi.string().required().min(2).max(50),
  email: Joi.string().email().required(),
  password: Joi.string().min(2), // Only required if not using Google to register
  googleId: Joi.string(),
}).xor('password', 'googleId'); // Ensure that either password or googleId is provided, not both

module.exports = {
  registerValidationSchema,
};