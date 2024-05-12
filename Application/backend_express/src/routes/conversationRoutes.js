const express = require('express');
const { checkAccessToken } = require('../middlewares/authMiddleware');
const { createConversationValidator, updateConversationValidator, addMessageValidator, paginationValidator} = require('../request-validators/conversationValidator');
const { validateObjectId } = require('../middlewares/mongooseMiddleware');
const conversationController = require('../controllers/conversationController');
const messageController = require('../controllers/messageController');

// Create a new router for the conversation routes
const router = express.Router();

// Apply checkAccessToken middleware to all routes in this router
router.use(checkAccessToken);

// Conversation routes
router.get('/:id', validateObjectId, conversationController.getConversation);
router.get('/', conversationController.getAllConversations);
router.post('/', createConversationValidator, conversationController.createConversation);
router.patch('/:id', validateObjectId, updateConversationValidator, conversationController.updateConversation);
router.delete('/:id', validateObjectId, conversationController.deleteConversation);

// Message routes for a specific conversation
router.get('/:conversationId/messages', validateObjectId, paginationValidator, messageController.getAllMessagesFromConversation);
router.post('/:conversationId/messages', validateObjectId, addMessageValidator, messageController.addMessageToConversation);


module.exports = router;
