require('dotenv').config();
const { isValidJwt, extractPayloadJwt } = require('../utils/authUtils');
const ApiResponse = require('../responses/apiResponse');

// Helper function to validate a token, this is used in all the middleware functions below
const checkToken = (req, res, token, secretKey, tokenType) => {
  if (!token) {
    ApiResponse.error(res, {
      statusCode: 401,
      error: `${tokenType} is missing or invalid.`
    });
    return false
  }

  if (!isValidJwt(token, secretKey)) {
    ApiResponse.error(res, {
      statusCode: 403,
      error: `Invalid ${tokenType}.`
    });
    return false;
  }

  const payload = extractPayloadJwt(token);
  if (!payload) {
    ApiResponse.error(res, {
      statusCode: 403,
      error: `Invalid ${tokenType} payload information.`
    });
    return false;
  }

  req.currentUser = payload;
  return true;
};

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
  const checkResult = checkToken(req, res, token, process.env.ACCESS_TOKEN_SECRET, 'access token');
  if (checkResult) next();
};

// Middleware to validate refresh token in the request body
const checkRefreshToken = (req, res, next) => {
  const { refreshToken } = req.body;
  const checkResult = checkToken(req, res, refreshToken, process.env.REFRESH_TOKEN_SECRET, 'refresh token');
  if (checkResult) next();
};

// Middleware to validate email verification token in the query parameters
const checkEmailVerificationToken = (req, res, next) => {
  const { token } = req.query;
  const checkResult = checkToken(req, res, token, process.env.VERIFICATION_TOKEN_SECRET, 'email verification token');
  if (checkResult) next();
};

// Middleware to validate forgot password token in the request body
const checkForgotPasswordToken = (req, res, next) => {
  const { forgotPasswordToken } = req.body;
  const checkResult = checkToken(req, res, forgotPasswordToken, process.env.FORGOT_PASSWORD_TOKEN_SECRET, 'forgot password token');
  if (checkResult) next();
};

// Middleware to validate worker token in the request body
const checkWorkerToken = (req, res, next) => {
  const { workerToken } = req.body;
  const checkResult = checkToken(req, res, workerToken, process.env.WORKER_TOKEN_SECRET, 'worker validation token');
  if (checkResult) next();
};

module.exports = {
  checkAccessToken,
  checkRefreshToken,
  checkEmailVerificationToken,
  checkForgotPasswordToken,
  checkWorkerToken
};