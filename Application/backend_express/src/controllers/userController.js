const ApiResponse = require('../responses/apiResponse');
const userService = require('../services/internal/userService');

const getProfile = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await userService.getProfileInformation(userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve the user profile information.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during user profile information retrieval. Please try again later.'
    });
  }
};

const getVerifiedStatus = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await userService.getVerifiedStatus(userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve the user verified status.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during user verified status retrieval. Please try again later.'
    });
  }
};

module.exports = {
  getProfile,
  getVerifiedStatus
};
