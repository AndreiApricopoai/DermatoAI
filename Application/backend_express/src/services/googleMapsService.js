require('dotenv').config();
const { Client } = require("@googlemaps/google-maps-services-js");
const client = new Client({});

const findDermatologicalClinics = async (latitude, longitude, radius) => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY;

  try {
    const response = await client.placesNearby({
      params: {
        location: { lat: latitude, lng: longitude },
        radius: radius,
        type: 'doctor',
        keyword: 'dermatological clinic',
        key: apiKey,
      },
      timeout: 10000
    });

    const clinics = response.data.results.map(clinic => ({
      name: clinic.name,
      location: {
        latitude: clinic.geometry.location.lat,
        longitude: clinic.geometry.location.lng
      },
      rating: clinic.rating,
      numberOfReviews: clinic.user_ratings_total,
      openStatus: clinic.opening_hours ? (clinic.opening_hours.open_now ? "Open" : "Closed") : "Not Available",
      placeId: clinic.place_id,
      googleMapsLink: `https://www.google.com/maps/place/?q=place_id:${clinic.place_id}`,
      address: clinic.vicinity,
      imageUrl: clinic.photos && clinic.photos.length > 0 
                ? `https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${clinic.photos[0].photo_reference}&key=${apiKey}` 
                : null
    }));

    return clinics;
  } catch (error) {
    console.error("Failed to fetch data from Google Maps:", error);
    throw error;
  }
};

module.exports = { findDermatologicalClinics };
