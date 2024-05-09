const Joi = require('joi');
const { handleValidationError } = require('../utils/validatorUtils');

const locationSchema = Joi.object({
  latitude: Joi.number().min(-90).max(90).required(),
  longitude: Joi.number().min(-180).max(180).required(),
  radius: Joi.number().min(1).max(50000).required() 
}).unknown(false);

const locationValidator = (req, res, next) => {
  const { latitude, longitude, radius } = req.query;
  const payload = { latitude, longitude, radius };
  const { error } = locationSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

const photoReferenceSchema = Joi.object({
  photoReference: Joi.string().required()
}).unknown(false);

const photoReferenceValidator = (req, res, next) => {
  const { photoReference } = req.params;
  const payload = { photoReference };
  const { error } = photoReferenceSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  locationValidator,
  photoReferenceValidator
};