// src/services/authService.js
const User = require('../models/user');
const RefreshToken = require('../models/refreshToken');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
require('dotenv').config();

// Helper function to create JWT access tokens
const createToken = (payload, secret, expiresIn) => {
  return jwt.sign(payload, secret, { expiresIn });
};

// Helper function to create and store refresh tokens
const createRefreshToken = async (user) => {
  const payload = { userId: user._id };
  const refreshToken = jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '7d' });
  const expires = new Date();
  expires.setDate(expires.getDate() + 7); // Set expiration date to 7 days in the future
  await new RefreshToken({
    token: refreshToken,
    user: user._id,
    expires
  }).save();
  return refreshToken;
};

// Login function
const login = async (credentials) => {
  const { email, password } = credentials;
  const user = await User.findOne({ email: email.toLowerCase() }).exec();
  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    return { type: 'error', status: 401, message: 'Invalid email or password' };
  }

  const token = createToken({ userId: user._id }, process.env.ACCESS_TOKEN_SECRET, '15m');
  const refreshToken = await createRefreshToken(user);

  return {
    type: 'success',
    status: 200,
    data: {
      message: 'Login successful',
      token,
      refreshToken,
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email
      }
    }
  };
};

// Register function
const register = async (userData) => {
  const { firstName, lastName, email, password, confirmPassword } = userData;

  if (password !== confirmPassword) {
    return { type: 'error', status: 400, message: 'Passwords do not match' };
  }

  let userExists = await User.findOne({ email: email.toLowerCase() });
  if (userExists) {
    return { type: 'error', status: 400, message: 'Email already exists' };
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const user = new User({
    firstName,
    lastName,
    email: email.toLowerCase(),
    passwordHash: hashedPassword
  });

  await user.save();
  const token = createToken({ userId: user._id }, process.env.ACCESS_TOKEN_SECRET, '15m');
  const refreshToken = await createRefreshToken(user);

  return {
    type: 'success',
    status: 200,
    data: {
      message: 'Registration successful',
      token,
      refreshToken,
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email
      }
    }
  };
};

// Logout function
const logout = async (userId, refreshToken) => {
  await RefreshToken.findOneAndRemove({ user: userId, token: refreshToken });
  return { type: 'success', status: 204, data: { message: 'Logged out successfully' } };
};

// Refresh token function
const getAccesToken = async (userId, refreshToken) => {
  const refreshTokenDoc = await RefreshToken.findOne({ user: userId, token: refreshToken });
  if (!refreshTokenDoc) {
    return { type: 'error', status: 400, message: 'Refresh token not found' };
  }

  const payload = { userId: userId };
  const newAccessToken = createToken(payload, process.env.ACCESS_TOKEN_SECRET, '15m');
  return { type: 'success', status: 200, data: { accessToken: newAccessToken } };
};



const handleGoogleCallback = async (user) => {
  if (!user) {
    return { type: 'error', status: 403, message: 'Authentication failed' };
  }

  const token = jwt.sign({
    sub: user._id,
    email: user.email
  }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1h' });

  return {
    type: 'success',
    status: 200,
    data: { token }
  };
};

module.exports = {
  login,
  register,
  logout,
  getAccesToken,
  handleGoogleCallback
};
