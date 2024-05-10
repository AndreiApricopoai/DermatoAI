const ApiResponse = require('../responses/apiResponse');
const authService = require('../services/authService');
require('dotenv').config();

// DermatoAI account login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const payload = { email, password };

    const result = await authService.login(payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to provide a valid login response.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during login. Please try again later.'
    });
  }
};

// DermatoAI account register
const register = async (req, res) => {
  try {
    const { firstName, lastName, email, password, confirmPassword } = req.body;
    const payload = { firstName, lastName, email, password, confirmPassword };

    const result = await authService.register(payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to provide a valid registration response.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during registration. Please try again later.'
    });
  }
};

// Google OAuth callback called by the register and login routes
const googleCallback = async (req, res) => {
  try {
    if (!req.user) {
      return ApiResponse.error(res, {
        statusCode: 401,
        error: 'Google authentication failed. Please try again.'
      });
    }

    const { _id, firstName, lastName } = req.user;
    const payload = { _id, firstName, lastName };

    const result = await authService.handleGoogleCallback(payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to provide a valid Google authentication response.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during Google authentication. Please try again later.'
    });
  }
};

// Logout both DermatoAI and Google accounts
const logout = async (req, res) => {
  try {
    const refreshToken = req.body.refreshToken;
    const userId = req.currentUser.userId;
    const result = await authService.logout(refreshToken, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to perform a valid logout operation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during logout. Please try again later.'
    });
  }
};

// Get a new access token based on the refresh token
const getAccessToken = async (req, res) => {
  try {
    const refreshToken = req.body.refreshToken;
    const userId = req.currentUser.userId;
    const result = await authService.getAccessToken(refreshToken, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve acces token.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during access token retrieval. Please try again later.'
    });
  }
};

module.exports = {
  register,
  login,
  googleCallback,
  logout,
  getAccessToken
};