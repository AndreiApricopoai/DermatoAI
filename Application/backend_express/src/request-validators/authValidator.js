const Joi = require('joi');
const { regexPatterns } = require('../utils/constants');
const { handleValidationError } = require('../utils/validatorUtils');

// Register validation schema using DermatoAI account
const registerSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required().regex(regexPatterns.nameRegex),
  lastName: Joi.string().min(2).max(50).required().regex(regexPatterns.nameRegex),
  email: Joi.string().email().required().regex(regexPatterns.emailRegex),
  password: Joi.string().min(3).required(),
  confirmPassword: Joi.string().min(3).required().valid(Joi.ref('password'))
}).unknown(false);

const registerValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = registerSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

// Login validation schema using DermatoAI account
const loginSchema = Joi.object({
  email: Joi.string().email().required().regex(regexPatterns.emailRegex),
  password: Joi.string().min(3).required(),
}).unknown(false);

const loginValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = loginSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

// Authentication using Google OAuth validation schema
const googleAuthSchema = Joi.object({
  _id: Joi.string().required(),
  firstName: Joi.string().min(2).max(50).required().regex(regexPatterns.nameRegex),
  lastName: Joi.string().min(2).max(50).required().regex(regexPatterns.nameRegex),
  email: Joi.string().email().required().regex(regexPatterns.emailRegex),
  googleId: Joi.string().required()
}).unknown(false);

const googleAuthValidator = (req, res, next) => {
  const user = req.user;
  const payload = {
    _id: user._id.toString(),
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    googleId: user.googleId
  };  
  const { error } = googleAuthSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  registerValidator,
  loginValidator,
  googleAuthValidator
};