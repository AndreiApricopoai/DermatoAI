const ApiResponse = require("../responses/apiResponse");
const locationService = require("../services/internal/locationService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getAllLocations = async (req, res) => {
  try {
    const { latitude, longitude, radius } = req.query;
    const params = { latitude, longitude, radius };

    const result = await locationService.findNearbyLocations(params);
    ApiResponse.handleResponse(res, result);
    
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGetAll,
    });
  }
};

const getLocationImage = async (req, res) => {
  try {
    const photoReference = req.params.photoReference;

    const result = await locationService.getImageFromMapsUrl(photoReference);
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
  getAllLocations,
  getLocationImage,
};