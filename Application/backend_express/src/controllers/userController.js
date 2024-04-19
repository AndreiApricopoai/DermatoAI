// src/controllers/userController.js
const userService = require('../services/userService');
const ApiResponse = require('../responses/apiResponse');

exports.registerUser = async (req, res) => {
  try {
    const user = await userService.createUser(req.body);
    ApiResponse.success(res, user, 'User created successfully', 201);
  } catch (error) {
    ApiResponse.error(res, error.message, 500);
  }
};

exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await userService.validateCredentials(email, password);

    if (!user) {
      return ApiResponse.error(res, 'Invalid credentials', 401);
    }

    // Generate token, handle session, etc.
    ApiResponse.success(res, { /* token and user info */ }, 'Login successful');
  } catch (error) {
    ApiResponse.error(res, error.message, 500);
  }
};
