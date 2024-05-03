const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// Helper function to create JWT token
const createJwtToken = (secretKey, expirationDate, payload) => {
  try {
    if (!payload || !secretKey) return null;

    const token = jwt.sign(
      payload,
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
    if (!token || !secretKey) return false;

    jwt.verify(token, secretKey);
    return true;
  } catch (error) {
    //console.error('Invalid JWT:', error);
    return false;
  }
};

// Helper function to extract payload from JWT token
const extractPayloadJwt = (jwtToken) => {
  try {
    if (!jwtToken) {
      console.error('No JWT token provided.');
      return null;
    }

    const decoded = jwt.decode(jwtToken);
    if (!decoded) {
      console.log('Decoded JWT:', decoded);
      console.error('Failed to decode JWT.');
      return null;
    }
    console.log('Decoded JWT:', decoded);

    return decoded;
  } catch (error) {
    console.error('Error extracting JWT payload:', error);
    return null;
  }
};

// Helper function to hash a token
const getTokenHash = (token) => {
  if (!token) return null;
  return crypto.createHash('sha256').update(token).digest('hex');
};

module.exports = {
  createJwtToken,
  isValidJwt,
  extractPayloadJwt,
  getTokenHash
};