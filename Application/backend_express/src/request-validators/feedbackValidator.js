const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");

const feedbackCreateSchema = Joi.object({
  category: Joi.string().valid('app', 'bugs', 'usability','predictions', 'AIchat', 'other').required(),
  content: Joi.string().min(10).max(1000).required(),
}).unknown(false);

const feedbackCreateValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = feedbackCreateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  feedbackCreateValidator
};
