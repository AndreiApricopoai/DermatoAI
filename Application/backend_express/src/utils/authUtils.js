const jwt = require('jsonwebtoken');

// Helper function to create JWT token
const createJwtToken = (secretKey, expirationDate, payload) => {
  try {
    const token = jwt.sign(
      {
        userId: payload.userId,
        firstName: payload.firstName,
        lastName: payload.lastName
      },
      secretKey,
      { expiresIn: expirationDate }
    );
    return token;
  } catch (error) {
    console.error('Error creating JWT:', error);
    return null;
  }
};

// Helper function to validate JWT token
const isValidJwt = (token, secretKey) => {
  try {
    jwt.verify(token, secretKey);
    return true;
  } catch (error) {
    console.error('Invalid JWT:', error);
    return false;
  }
};

// Helper function to extract payload from JWT token
const extractPayloadJwt = (jwtToken) => {
  try {
    const decoded = jwt.decode(jwtToken);
    if (!decoded) {
      return null;
    }
    const { userId, firstName, lastName } = decoded;
    return { userId, firstName, lastName };
  } catch (error) {
    console.error('Error extracting JWT payload:', error);
    return null;
  }
};

module.exports = {
  createJwtToken,
  isValidJwt,
  extractPayloadJwt
};