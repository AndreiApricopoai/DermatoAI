const ApiResponse = require("../responses/apiResponse");
const feedbackService = require("../services/internal/feedbackService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const createFeedback = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const { category, content } = req.body;
    const payload = { category, content };

    const result = await feedbackService.createFeedback(userId, payload);
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
  createFeedback,
};