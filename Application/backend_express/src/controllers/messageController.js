const ApiResponse = require('../responses/apiResponse');
const messageService = require('../services/messageService');

// Get all messages from a specific conversation for the current user
const getAllMessagesFromConversation = async (req, res) => {
  try {
    const conversationId = req.params.conversationId;
    const userId = req.currentUser.userId;
    const { page, limit } = req.pagination;

    const result = await messageService.getAllMessagesByConversationId(conversationId, userId, page, limit);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve messages from the conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during messages retrieval. Please try again later.'
    });
  }
};

// Add a message to a specific conversation for the current user
const addMessageToConversation = async (req, res) => {
  try {
    const conversationId = req.params.conversationId;
    const userId = req.currentUser.userId;
    const { messageContent } = req.body;

    const result = await messageService.addMessageToConversation(conversationId, userId, messageContent);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to add a message to the conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during message addition. Please try again later.'
    });
  }
};

module.exports = {
  getAllMessagesFromConversation,
  addMessageToConversation
};
