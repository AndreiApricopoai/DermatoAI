const ApiResponse = require("../responses/apiResponse");
const conversationService = require("../services/internal/conversationService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await conversationService.getConversationById(
      conversationId,
      userId
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGet,
    });
  }
};

const getAllConversations = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result =
      await conversationService.getAllConversationsByUserId(userId);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGetAll,
    });
  }
};

const createConversation = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const { title } = req.body;
    const payload = { title };

    const result = await conversationService.createConversation(
      userId,
      payload
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorCreate,
    });
  }
};

const updateConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await conversationService.updateConversation(
      conversationId,
      userId,
      updatePayload
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorUpdate,
    });
  }
};

const deleteConversation = async (req, res) => {
  try {
    const conversationId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await conversationService.deleteConversation(
      conversationId,
      userId
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorDelete,
    });
  }
};

module.exports = {
  getConversation,
  getAllConversations,
  createConversation,
  updateConversation,
  deleteConversation,
};
