const User = require('../models/userModel');
const RefreshToken = require('../models/refreshTokenModel');
const { createJwtToken, extractPayloadJwt, getTokenHash } = require('../utils/authUtils');
require('dotenv').config();

// Login function for DermatoAI account
const login = async (payload) => {
  const email = payload.email.toLowerCase();
  const password = payload.password;

  try {
    const user = await User.findOne({ email: email }).exec();
    if (!user) {
      return {
        type: 'error',
        status: 400,
        error: 'User with this email does not exist.'
      };
    }

    if (user.googleId) {
      return {
        type: 'error',
        status: 400,
        error: 'User with this email exists. Please login with Google.'
      };
    }

    const passwordValid = await user.validatePassword(password);
    if (!passwordValid) {
      return {
        type: 'error',
        status: 400,
        error: 'Invalid password.'
      };
    }

    const tokenPayload = {
      userId: user._id,
      firstName: user.firstName,
      lastName: user.lastName
    };

    const token = createJwtToken(process.env.ACCESS_TOKEN_SECRET, '15m', tokenPayload);
    const refreshToken = createJwtToken(process.env.REFRESH_TOKEN_SECRET, '7d', tokenPayload);

    if (!token || !refreshToken) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while creating the tokens.'
      };
    }

    // Store refresh token in database
    const saveResult = await saveRefreshTokenToCollection(refreshToken, user._id);

    if (!saveResult) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while saving the refresh token.'
      };
    }

    return {
      type: 'success',
      status: 200,
      data: {
        message: 'Login successful.',
        token,
        refreshToken,
      }
    };
  }
  catch (error) {
    console.error('Login service error:', error);
    return {
      type: 'error',
      status: 500,
      error: 'An unexpected error occurred during login. Please try again later.'
    };
  }
};

// Register function for DermatoAI account
const register = async (payload) => {
  const { firstName, lastName, email, password } = payload;

  try {
    const userExists = await User.findOne({ email: email.toLowerCase() }).exec();
    if (userExists) {
      return {
        type: 'error',
        status: 400,
        error: 'User with this email already exists.'
      };
    }

    const user = new User({
      firstName,
      lastName,
      email: email.toLowerCase(),
      passwordHash: password
    });

    await user.save();

    const tokenPayload = {
      userId: user._id,
      firstName: user.firstName,
      lastName: user.lastName
    };

    const token = createJwtToken(process.env.ACCESS_TOKEN_SECRET, '15m', tokenPayload);
    const refreshToken = createJwtToken(process.env.REFRESH_TOKEN_SECRET, '7d', tokenPayload);

    if (!token || !refreshToken) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while creating the tokens.'
      };
    }

    // Store refresh token in database
    const saveResult = await saveRefreshTokenToCollection(refreshToken, user._id);

    if (!saveResult) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while saving the refresh token.'
      };
    }

    return {
      type: 'success',
      status: 200,
      data: {
        message: 'Registration successful.',
        token,
        refreshToken,
      }
    };
  }
  catch (error) {
    console.error('Register service error:', error);
    return {
      type: 'error',
      status: 500,
      error: 'An unexpected error occurred during registration. Please try again later.'
    };
  }
};

// Google OAuth callback function
const handleGoogleCallback = async (payload) => {
  const { _id, firstName, lastName } = payload;

  try {
    const tokenPayload = {
      userId: _id,
      firstName: firstName,
      lastName: lastName
    };

    const token = createJwtToken(process.env.ACCESS_TOKEN_SECRET, '15m', tokenPayload);
    const refreshToken = createJwtToken(process.env.REFRESH_TOKEN_SECRET, '7d', tokenPayload);

    if (!token || !refreshToken) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while creating the tokens.'
      };
    }

    // Store refresh token in database
    const saveResult = await saveRefreshTokenToCollection(refreshToken, _id);

    if (!saveResult) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while saving the refresh token.'
      };
    }

    return {
      type: 'success',
      status: 200,
      data: {
        message: 'Google authentication successful.',
        token,
        refreshToken,
      }
    };
  }
  catch (error) {
    console.error('Google authentication service error.', error);
    return {
      type: 'error',
      status: 500,
      error: 'An error occurred while trying to authenticate using Google. Please try again later.'
    };
  }
};

// Logout function from both DermatoAI and Google accounts
const logout = async (refreshToken, userId) => {
  try {
    const refreshTokenHash = getTokenHash(refreshToken);
    const result = await RefreshToken.findOneAndDelete({ user: userId, tokenHash: refreshTokenHash }).exec();
    console.log('Logout result:', result);

    if (!refreshTokenHash || !result) {
      return {
        type: 'error',
        status: 404,
        error: 'No token found. Perhaps the user is already logged out.'
      };
    }

    return {
      type: 'success',
      status: 200,
      data: { message: 'Logged out successfully.' }
    };
  }
  catch (error) {
    console.error('Error during logout:', error);
    return {
      type: 'error',
      status: 500,
      error: 'An unexpected error occurred during logout. Please try again later.'
    };
  }
};

// Get a new access token using a refresh token
const getAccessToken = async (refreshToken, userId) => {
  try {
    const refreshTokenHash = getTokenHash(refreshToken);
    const existsRefreshToken = await RefreshToken.findOne({ user: userId, tokenHash: refreshTokenHash }).exec();

    if (!refreshTokenHash || !existsRefreshToken) {
      return {
        type: 'error',
        status: 404,
        error: 'Refresh token not found.'
      };
    }

    if (existsRefreshToken.expires < new Date()) {
      await RefreshToken.findByIdAndDelete(existsRefreshToken._id).exec();
      return {
        type: 'error',
        status: 401,
        error: 'Refresh token has expired.'
      };
    }

    const extracted = extractPayloadJwt(refreshToken);

    if (!extracted) {
      return {
        type: 'error',
        status: 401,
        error: 'Token payload could not be extracted.'
      };
    }
    const newAccessTokenPayload = {
      userId: extracted.userId,
      firstName: extracted.firstName,
      lastName: extracted.lastName
    };
    const newAccessToken = createJwtToken(process.env.ACCESS_TOKEN_SECRET, '15m', newAccessTokenPayload);

    if (!newAccessToken) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while creating a new acces token.'
      };
    }

    return {
      type: 'success',
      status: 200,
      data: {
        message: 'New access token generated successfully.',
        token: newAccessToken
      }
    };
  }
  catch (error) {
    console.error('Error during new access token generation:', error);
    return {
      type: 'error',
      status: 500,
      error: 'An unexpected error occurred during access token retrieval. Please try again later.'
    };
  }
};

// PRIVATE helper function to create a refresh token in the database
const saveRefreshTokenToCollection = async (refreshToken, userId) => {
  const expirationDate = new Date();
  expirationDate.setDate(expirationDate.getDate() + 7); // 7 days in the future

  const hash = getTokenHash(refreshToken);
  if (!hash) {
    console.error('Error creating token hash.');
    return false;
  }

  await new RefreshToken({
    user: userId,
    tokenHash: hash,
    expires: expirationDate
  }).save();

  return true;
};

module.exports = {
  login,
  register,
  logout,
  getAccessToken,
  handleGoogleCallback
};