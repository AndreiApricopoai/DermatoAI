const googleMapsService = require('../services/googleMapsService');

const findNearbyLocations = async (params) => {
  try {
    const { latitude, longitude, radius } = params;

    // Call Google Maps service to find dermatological clinics
    const clinics = await googleMapsService.findDermatologicalClinics(latitude, longitude, radius);

    if(!clinics) {
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

module.exports = { findNearbyLocations };
