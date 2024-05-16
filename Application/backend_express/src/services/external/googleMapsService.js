require("dotenv").config();
const {
  getGoogleMapsPlaceUrl,
  GOOGLE_DERMATOLOGICAL_PLACE,
} = require("../utils/constants");
const { Client } = require("@googlemaps/google-maps-services-js");
const client = new Client({});

const findDermatologicalClinics = async (latitude, longitude, radius) => {
  try {
    const response = await client.placesNearby({
      params: {
        location: { lat: latitude, lng: longitude },
        radius: radius,
        type: GOOGLE_DERMATOLOGICAL_PLACE.type,
        keyword: GOOGLE_DERMATOLOGICAL_PLACE.keyword,
        key: process.env.GOOGLE_MAPS_API_KEY,
      },
      timeout: 10000,
    });

    const clinics = response.data.results.map((clinic) => ({
      name: clinic.name,
      location: {
        latitude: clinic.geometry.location.lat,
        longitude: clinic.geometry.location.lng,
      },
      rating: clinic.rating,
      numberOfReviews: clinic.user_ratings_total,
      openStatus: clinic.opening_hours
        ? clinic.opening_hours.open_now
          ? "Open"
          : "Closed"
        : "Not Available",
      placeId: clinic.place_id,
      googleMapsLink: getGoogleMapsPlaceUrl(clinic.place_id),
      address: clinic.vicinity,
      photoReference:
        clinic.photos && clinic.photos.length > 0
          ? clinic.photos[0].photo_reference
          : null,
    }));

    return clinics;
  } catch (error) {
    console.error("Failed to fetch data from Google Maps:", error);
    throw error;
  }
};

module.exports = { findDermatologicalClinics };