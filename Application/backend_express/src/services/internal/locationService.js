require("dotenv").config();
const { getGoogleMapsPhotoUrl } = require("../../utils/constants");
const axios = require("axios");
const googleMapsService = require("../external/googleMapsService");
const {
  ErrorMessages,
  StatusCodes,
  ResponseTypes,
} = require("../../responses/apiConstants");

const findNearbyLocations = async (params) => {
  try {
    const { latitude, longitude, radius } = params;

    const clinics = await googleMapsService.findDermatologicalClinics(
      latitude,
      longitude,
      radius
    );

    if (!clinics) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: ErrorMessages.FetchError,
      };
    }

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: clinics,
    };
  } catch (error) {
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const getImageFromMapsUrl = async (photoReference) => {
  try {
    const photoUrl = getGoogleMapsPhotoUrl(photoReference);
    const response = await axios.get(photoUrl, {
      responseType: "arraybuffer",
    });

    if (!response || !response.data) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: ErrorMessages.FetchError,
      };
    }

    const imageBase64 = Buffer.from(response.data, "binary").toString("base64");
    if (!imageBase64) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: ErrorMessages.FetchError,
      };
    }

    const responseImage = {
      image : `data:image/jpeg;base64,${imageBase64}`
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseImage,
    };
  } catch (error) {
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.FetchError,
    };
  }
};

module.exports = {
  findNearbyLocations,
  getImageFromMapsUrl,
};
