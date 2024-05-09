const ApiResponse = require('../responses/apiResponse');
const conversationService = require('../services/conversationService');

// Get a single conversation by conversation ID for the current user
const getConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await conversationService.getConversationById(conversationId, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during conversation retrieval. Please try again later.'
    });
  }
};

// Get all conversations for the current user
const getAllConversations = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await conversationService.getAllConversationsByUserId(userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve all conversations.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during conversations retrieval. Please try again later.'
    });
  }
};

// Create a new conversation for the current user
const createConversation = async (req, res) => {
  try {
    const { title } = req.body;
    const payload = { title };
    const userId = req.currentUser.userId;

    const result = await conversationService.createConversation(userId, payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to create a new conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during conversation creation. Please try again later.'
    });
  }
};

// Update an existing conversation for the current user
const updateConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await conversationService.updateConversation(conversationId, userId, updatePayload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to update the conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during conversation update. Please try again later.'
    });
  }
};

// Delete a conversation by conversation ID for the current user
const deleteConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await conversationService.deleteConversation(conversationId, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to delete the conversation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during conversation deletion. Please try again later.'
    });
  }
};

module.exports = {
  getConversation,
  getAllConversations,
  createConversation,
  updateConversation,
  deleteConversation
};
