const ApiResponse = require("../responses/apiResponse");
const locationService = require("../services/locationService");
require("dotenv").config();

const getAllLocations = async (req, res) => {
  try {
    const { latitude, longitude, radius } = req.query;
    const params = { latitude, longitude, radius };

    const result = await locationService.findNearbyLocations(params);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } 
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: "The service failed to povide the nearby locations.",
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error:
        "An unexpected error occurred while fetching the nearby locations. Please try again later.",
    });
  }
};

const getLocationImage = async (req, res) => {
  try {
      const photoReference = req.params.photoReference;
      const imageUrl = imageService.getImageUrl(photoReference);  // Get URL from the service

      return ApiResponse.success(res, { data: { imageUrl } });
  } catch (error) {
      console.log(error);
      if (error.message === "The photo reference is required.") {
          return ApiResponse.error(res, {
              statusCode: 400,
              error: error.message
          });
      }
      return ApiResponse.error(res, {
          statusCode: 500,
          error: "An unexpected error occurred while fetching the location image. Please try again later."
      });
  }
};

module.exports = {
  getAllLocations,
  getLocationImage
};
