// src/controllers/authController.js
const ApiResponse = require('../responses/apiResponse'); // Ensure the path is correct
const authService = require('../services/authService'); // Handle the logic
//const loginValidator = require('../validators/loginValidator'); // For validating login input
//const registerValidator = require('../validators/registerValidator'); // For validating registration input

const jwt = require('jsonwebtoken');

const googleAuthCallback = (req, res) => {
  if (!req.user) {
    return res.status(401).json({ message: 'Authentication failed' });
  }
  // Generate JWT
  const token = jwt.sign({
    sub: req.user._id,
    email: req.user.email
  }, process.env.JWT_SECRET, { expiresIn: '1h' });

  res.json({ token });
};

// Standard account registration
const register = async (req, res) => {
  //const { error } = registerValidator(req.body);
  //if (error) return res.status(400).json({ message: error.details[0].message });

  // authService.register would contain the logic to register a user with the provided credentials
  const result = await authService.register(req.body);
  res.status(result.status).json(result.data);
};

// Standard account login
const login = async (req, res) => {
  //const { error } = loginValidator(req.body);
  //if (error) return res.status(400).json({ message: error.details[0].message });

  // authService.login would contain the logic to authenticate a user with the provided credentials
  const result = await authService.login(req.body);

  ApiResponse.handleResponse(res, result);
};

// Google account registration
const googleRegister = async (req, res) => {
  // authService.googleRegister would handle the logic of registering a user with their Google account
  const result = await authService.googleRegister(req.body);
  res.status(result.status).json(result.data);
};

// Google account login
const googleLogin = async (req, res) => {
  // authService.googleLogin would handle the logic of logging in a user with their Google account
  const result = await authService.googleLogin(req.body);
  res.status(result.status).json(result.data);
};

const logout = async (req, res) => {
    // authService.logout would handle the logic of logging out a user
    const result = await authService.logout(req.body.refreshToken);
    res.status(result.status).json(result.data);
};

const getToken = async (req, res) => {
    // authService.getToken would handle the logic of getting a new token using a refresh token
    const result = await authService.getToken(req.body.refreshToken);
    res.status(result.status).json(result.data);
};

module.exports = {
  register,
  login,
  googleRegister,
  googleLogin,
  googleAuthCallback,
  logout,
  getToken
};
