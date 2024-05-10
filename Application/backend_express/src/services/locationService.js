require("dotenv").config();
const axios = require("axios");
const googleMapsService = require("../services/googleMapsService");

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
        type: "error",
        status: 500,
        error: "Failed to retrieve locations.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: clinics,
    };
  } catch (error) {
    console.error("Error retrieving nearby locations:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve locations.",
    };
  }
};

const getImageFromMapsUrl = async (photoReference) => {
  try {
    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${apiKey}`;

    const response = await axios.get(photoUrl, {
      responseType: "arraybuffer",
    });

    if (!response.data) {
      return {
        type: "error",
        status: 500,
        error: "Could not fetch image.",
      };
    }

    const imageBase64 = Buffer.from(response.data, "binary").toString("base64");

    if (!imageBase64) {
      return {
        type: "error",
        status: 500,
        error: "Could not fetch image.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: `data:image/jpeg;base64,${imageBase64}`,
    };
  } catch (error) {
    console.error("Failed to fetch image:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred while fetching the image. Please try again later.",
    };
  }
};

module.exports = {
  findNearbyLocations,
  getImageFromMapsUrl,
};
