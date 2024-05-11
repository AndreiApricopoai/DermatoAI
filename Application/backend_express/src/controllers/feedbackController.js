const ApiResponse = require('../responses/apiResponse');
const feedbackService = require('../services/feedbackService');

// Get a single appointment by appointment ID for the current user
const createFeedback = async (req, res) => {
  try {
    const { category, content } = req.body;
    const payload = { category, content };
    const userId = req.currentUser.userId;

    const result = await feedbackService.createFeedback(userId, payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to create the feedback.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred\ during the feedback creation. Please try again later.'
    });
  }
};

module.exports = {
  createFeedback
};