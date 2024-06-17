const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");

const createAppointmentSchema = Joi.object({
  title: Joi.string().trim().min(1).max(100).required(),
  description: Joi.string().trim().max(500).optional(),
  appointmentDate: Joi.date().min(new Date()).required(),
  institutionName: Joi.string().trim().max(100).optional(),
  address: Joi.string().trim().max(200).optional(),
}).unknown(false);

const createAppointmentValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = createAppointmentSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

const updateAppointmentSchema = Joi.object({
  title: Joi.string().trim().min(1).max(100).optional(),
  description: Joi.string().trim().max(500).optional(),
  appointmentDate: Joi.date().min(new Date()).optional(),
  institutionName: Joi.string().trim().max(100).optional(),
  address: Joi.string().trim().max(200).optional(),
})
  .or("title", "description", "appointmentDate", "institutionName", "address")
  .unknown(false);

const updateAppointmentValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = updateAppointmentSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  createAppointmentValidator,
  updateAppointmentValidator,
};
