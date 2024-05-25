const Joi = require("joi");
const { regexPatterns } = require("../utils/constants");
const { handleValidationError } = require("../utils/validatorUtils");

// Register validation schema using DermatoAI account
const registerSchema = Joi.object({
  firstName: Joi.string()
    .trim()
    .min(2)
    .max(50)
    .required()
    .regex(regexPatterns.nameRegex),
  lastName: Joi.string()
    .trim()
    .min(2)
    .max(50)
    .required()
    .regex(regexPatterns.nameRegex),
  email: Joi.string().trim().email().required().regex(regexPatterns.emailRegex),
  password: Joi.string().min(3).required(),
  confirmPassword: Joi.string().min(3).required().valid(Joi.ref("password")),
}).unknown(false);

const registerValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = registerSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

// Login validation schema using DermatoAI account
const loginSchema = Joi.object({
  email: Joi.string().trim().email().required().regex(regexPatterns.emailRegex),
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
  firstName: Joi.string()
    .min(2)
    .max(50)
    .required()
    .regex(regexPatterns.nameRegex),
  lastName: Joi.string()
    .min(2)
    .max(50)
    .required()
    .regex(regexPatterns.nameRegex),
  email: Joi.string().trim().email().required().regex(regexPatterns.emailRegex),
  googleId: Joi.string().required(),
  profilePhoto: Joi.string().optional(),
  verified: Joi.boolean().required(),
}).unknown(false);

const googleAuthValidator = (req, res, next) => {
  const user = req.user;

  if (user.isSuccess === true) {
    const payload = {
      _id: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      googleId: user.googleId,
      profilePhoto: user.profilePhoto,
      verified: user.verified,
    };
    const { error } = googleAuthSchema.validate(payload, { abortEarly: false });
    if (error) {
      return res.status(400).json({
        isSuccess: false,
        message: "Validation failed",
        apiResponseCode: 3,
        errors: error.details,
      });
    }
  }
  next();
};

// Email validation schema for email verification
const emailSchema = Joi.object({
  email: Joi.string().trim().email().required().regex(regexPatterns.emailRegex),
}).unknown(false);

const emailValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = emailSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

// Get a new access token based on the refresh token 
const getAccesTokenSchema = Joi.object({
  refreshToken: Joi.string().required(),
}).unknown(false);

const getAccesTokenValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = getAccesTokenSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

// Change password validation schema
const changePasswordSchema = Joi.object({
  oldPassword: Joi.string().min(3).required(),
  password: Joi.string().min(3).required(),
  confirmPassword: Joi.string().min(3).required().valid(Joi.ref("password")),
}).unknown(false);

const changePasswordValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = changePasswordSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

// Reset password validation schema
const resetPasswordSchema = Joi.object({
  forgotPasswordToken: Joi.string().required(),
  password: Joi.string().min(3).required(),
  confirmPassword: Joi.string().min(3).required().valid(Joi.ref("password")),
}).unknown(false);

const resetPasswordValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = resetPasswordSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  registerValidator,
  loginValidator,
  googleAuthValidator,
  getAccesTokenValidator,
  emailValidator,
  changePasswordValidator,
  resetPasswordValidator,
};
