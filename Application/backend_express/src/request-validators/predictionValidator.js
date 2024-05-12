const Joi = require("joi");
const { handleValidationError } = require("../utils/validatorUtils");


const CLASS_INDICES_NAMES = {
  0: 'actinic keratosis',
  1: 'basal cell carcinoma',
  2: 'dermatofibroma',
  3: 'melanoma',
  4: 'nevus',
  5: 'pigmented benign keratosis',
  6: 'squamous cell carcinoma',
  7: 'vascular lesion'
};
const diagnosisOptions = Object.values(CLASS_INDICES_NAMES);


const predictionUserUpdateSchema = Joi.object({
  title: Joi.string().min(1).max(100).optional(),
  description: Joi.string().min(1).max(1000).optional(),
}).or("title", "description")
.unknown(false);

const predictionUserUpdateValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = predictionUserUpdateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

// Update appointment validation schema
const predictionWorkerUpdateSchema = Joi.object({
  userId: Joi.string().required(),
  workerToken: Joi.string().required(),
  isHealthy: Joi.boolean(),
  diagnosisName: Joi.string().valid(...diagnosisOptions),
  diagnosisCode: Joi.number().integer().min(0).max(9),
  diagnosisType: Joi.string().valid('cancer', 'not_cancer', 'potentially_cancer', 'unknown'),
  confidenceLevel: Joi.number().min(0).max(100),
  status: Joi.string().valid('pending', 'processed', 'failed').required(),
}).unknown(false);

const predictionWorkerUpdateValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = predictionWorkerUpdateSchema.validate(payload, {
    abortEarly: false,
  });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  predictionUserUpdateValidator,
  predictionWorkerUpdateValidator,
};
