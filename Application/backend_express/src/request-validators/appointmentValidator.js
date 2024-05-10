const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");

function getCurrentDate() {
  const date = new Date();
  return date;
}

// Create appointment validation schema
const appointmentCreateSchema = Joi.object({
  title: Joi.string().min(1).max(100).required(),
  description: Joi.string().min(1).max(500).optional(),
  appointmentDate: Joi.date().min(getCurrentDate()).required(),
  institutionName: Joi.string().min(1).max(200).optional(),
  address: Joi.string().min(1).max(300).optional(),
}).unknown(false);

const createAppointmentValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = appointmentCreateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

// Update appointment validation schema
const appointmentUpdateSchema = Joi.object({
  title: Joi.string().min(1).max(100).optional(),
  description: Joi.string().min(1).max(500).optional(),
  appointmentDate: Joi.date().min(getCurrentDate()).optional(),
  institutionName: Joi.string().min(1).max(200).optional(),
  address: Joi.string().min(1).max(300).optional(),
})
  .or("title", "description", "appointmentDate", "institutionName", "address")
  .unknown(false);

const updateAppointmentValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = appointmentUpdateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  createAppointmentValidator,
  updateAppointmentValidator,
};
