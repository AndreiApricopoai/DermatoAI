const { isValidJwt, extractPayloadJwt } = require('../utils/authUtils');
const ApiResponse = require('../responses/apiResponse');
require('dotenv').config();

// Middleware to validate access token in the Authorization header
const checkAccessToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return ApiResponse.error(res, {
      statusCode: 401,
      error: 'Access token is missing or invalid.'
    });
  }

  const token = authHeader.split(' ')[1];

  if (!isValidJwt(token, process.env.ACCESS_TOKEN_SECRET)) {
    return ApiResponse.error(res, {
      statusCode: 403,
      error: 'Authentication failed due to an invalid token.'
    });
  }

  const payload = extractPayloadJwt(token);
  if (!payload) {
    return ApiResponse.error(res, {
      statusCode: 403,
      error: 'Authentication failed due to an invalid token.'
    });
  }

  req.currentUser = payload;
  next();
};

// Middleware to validate refresh token in the request body
const checkRefreshToken = (req, res, next) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return ApiResponse.error(res, {
      statusCode: 401,
      error: 'Refresh token is missing or invalid.'
    });
  }

  if (!isValidJwt(refreshToken, process.env.REFRESH_TOKEN_SECRET)) {
    return ApiResponse.error(res, {
      statusCode: 403,
      error: 'Invalid refresh token.'
    });
  }

  const payload = extractPayloadJwt(token);
  if (!payload) {
    return ApiResponse.error(res, {
      statusCode: 403,
      error: 'Invalid refresh token.'
    });
  }

  req.currentUser = payload;
  next();
};

// Middleware to validate worker token in the request body
const checkWorkerToken = (req, res, next) => {
  const { workerToken } = req.body;

  if (!workerToken) {
    return ApiResponse.error(res, {
      statusCode: 401,
      error: 'Worker validation token is missing or invalid.'
    });
  }

  if (!isValidJwt(refreshToken, process.env.REFRESH_TOKEN_SECRET)) {
    return ApiResponse.error(res, {
      statusCode: 403,
      error: 'Invalid refresh token.'
    });
  }

  req.currentUser = extractPayloadJwt(refreshToken);
  next();
};

module.exports = {
  checkAccessToken,
  checkRefreshToken,
  checkWorkerToken
};