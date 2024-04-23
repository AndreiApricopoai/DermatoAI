const Joi = require('joi');
const ApiResponse = require('../responses/apiResponse');
const { nameRegex, emailRegex } = require('../utils/constants');

// Register validation schema using DermatoAI account
const registerSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required().regex(nameRegex),
  lastName: Joi.string().min(2).max(50).required().regex(nameRegex),
  email: Joi.string().email().required().regex(emailRegex),
  password: Joi.string().min(3).required(),
  confirmPassword: Joi.string().min(3).required().valid(Joi.ref('password'))
});

const registerValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = registerSchema.validate(payload);

  if (error) {
    return ApiResponse.validationError(res, {
      statusCode: 400,
      errors: error.details.map(detail => ({
        message: detail.message,
        path: detail.path.join('.')
      }))
    });
  }
  next();
};

// Login validation schema using DermatoAI account
const loginSchema = Joi.object({
  email: Joi.string().email().required().regex(emailRegex),
  password: Joi.string().min(3).required(),
});

const loginValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = loginSchema.validate(payload);

  if (error) {
    return ApiResponse.validationError(res, {
      statusCode: 400,
      errors: error.details.map(detail => ({
        message: detail.message,
        path: detail.path.join('.')
      }))
    });
  }
  next();
};

module.exports = {
  registerValidator,
  loginValidator
};
