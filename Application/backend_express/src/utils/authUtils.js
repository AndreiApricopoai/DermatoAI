const jwt = require("jsonwebtoken");
const crypto = require("crypto");

const createJwtToken = (secretKey, expirationDate, payload) => {
  try {
    if (!payload || !secretKey) return null;
    const token = jwt.sign(payload, secretKey, { expiresIn: expirationDate });
    return token;
  } catch (error) {
    return null;
  }
};

const isValidJwt = (token, secretKey) => {
  try {
    if (!token || !secretKey) return false;
    jwt.verify(token, secretKey);
    return true;
  } catch (error) {
    return false;
  }
};

const extractPayloadJwt = (jwtToken) => {
  try {
    if (!jwtToken) {
      return null;
    }

    const decoded = jwt.decode(jwtToken);
    if (!decoded) {
      return null;
    }
    return decoded;
  } catch (error) {
    return null;
  }
};

const getTokenHash = (token) => {
  if (!token) return null;
  return crypto.createHash("sha256").update(token).digest("hex");
};

module.exports = {
  createJwtToken,
  isValidJwt,
  extractPayloadJwt,
  getTokenHash,
};
