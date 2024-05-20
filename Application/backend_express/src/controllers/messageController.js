const ApiResponse = require("../responses/apiResponse");
const messageService = require("../services/internal/messageService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getAllMessagesFromConversation = async (req, res) => {
  try {
    const conversationId = req.params.conversationId;
    const userId = req.currentUser.userId;
    const { page, limit } = req.pagination;

    const result = await messageService.getAllMessagesByConversationId(
      conversationId,
      userId,
      page,
      limit
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGetAll,
    });
  }
};

const addMessageToConversation = async (req, res) => {
  try {
    const conversationId = req.params.conversationId;
    const userId = req.currentUser.userId;
    const { messageContent } = req.body;

    const result = await messageService.addMessageToConversation(
      conversationId,
      userId,
      messageContent
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

module.exports = {
  getAllMessagesFromConversation,
  addMessageToConversation,
};
