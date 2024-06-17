const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");

const createFeedbackSchema = Joi.object({
  category: Joi.string()
    .valid("app", "bugs", "usability", "predictions", "AIchat", "other")
    .required(),
  content: Joi.string().trim().min(10).max(1000).required(),
}).unknown(false);

const createFeedbackValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = createFeedbackSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  createFeedbackValidator,
};
