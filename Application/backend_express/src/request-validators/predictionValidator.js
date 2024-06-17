const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");
const {
  CLASS_INDICES_NAMES,
  PREDICTION_STATUS,
  DIAGNOSIS_TYPE,
} = require("../utils/constants");

const diagnosisOptions = Object.values(CLASS_INDICES_NAMES);
const statusOptions = Object.values(PREDICTION_STATUS);
const diagnosisTypeOptions = Object.values(DIAGNOSIS_TYPE);

const updateUserPredictionSchema = Joi.object({
  title: Joi.string().trim().min(1).max(100).optional(),
  description: Joi.string().trim().max(1000).allow("").optional(),
})
  .or("title", "description")
  .unknown(false);

const updateUserPredictionValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = updateUserPredictionSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

const predictionWorkerUpdateSchema = Joi.object({
  userId: Joi.string().required(),
  workerToken: Joi.string().required(),
  isHealthy: Joi.boolean(),
  diagnosisName: Joi.string().valid(...diagnosisOptions),
  diagnosisCode: Joi.number().integer().min(0).max(9),
  diagnosisType: Joi.string().valid(...diagnosisTypeOptions),
  confidenceLevel: Joi.number().min(0).max(1),
  status: Joi.string()
    .valid(...statusOptions)
    .required(),
}).unknown(false);

const updateWorkerPredictionValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = predictionWorkerUpdateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  updateUserPredictionValidator,
  updateWorkerPredictionValidator,
};
