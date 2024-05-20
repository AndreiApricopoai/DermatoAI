const ApiResponse = require("../responses/apiResponse");
const userService = require("../services/internal/userService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getProfile = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await userService.getProfileInformation(userId);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGet,
    });
  }
};

const getVerifiedStatus = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await userService.getVerifiedStatus(userId);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGet,
    });
  }
};

module.exports = {
  getProfile,
  getVerifiedStatus,
};
