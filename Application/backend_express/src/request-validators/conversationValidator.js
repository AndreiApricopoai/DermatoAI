const Joi = require('joi');
const { handleValidationError } = require('../utils/validatorUtils');

// Conversation validation schema
const conversationCreateSchema = Joi.object({
  title: Joi.string().min(1).max(100).required()
}).unknown(false);

const createConversationValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = conversationCreateSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

const conversationUpdateSchema = Joi.object({
  title: Joi.string().min(1).max(100).optional()
}).or('title').unknown(false);

const updateConversationValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = conversationUpdateSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

// Message validation schema
const messageSchema = Joi.object({
  messageContent: Joi.string().min(1).max(1000).required(),
}).unknown(false);

const addMessageValidator = (req, res, next) => {
  const payload = req.body;
  const { error } = messageSchema.validate(payload, { abortEarly: false });

  if (handleValidationError(error, res)) return;
  next();
};

module.exports = {
  createConversationValidator,
  updateConversationValidator,
  addMessageValidator
};
