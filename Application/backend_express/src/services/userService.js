// src/services/userService.js
const User = require('../models/user');
const bcrypt = require('bcrypt');

const createUser = async (userData) => {
  // Here you can add additional logic before creating a user,
  // such as business rules validation, preprocessing, etc.

  // Hash the password before saving the user
  if (userData.password) {
    const salt = await bcrypt.genSalt(10);
    userData.passwordHash = await bcrypt.hash(userData.password, salt);
    delete userData.password; // Remove plaintext password field
  }

  // Create the user
  const user = new User(userData);
  await user.save();
  
  // You can also remove sensitive information before returning the user data
  user.passwordHash = undefined;
  user.salt = undefined;

  return user;
};

const validateCredentials = async (email, password) => {
  // Find the user by email
  const user = await User.findOne({ email });
  if (!user) {
    return false; // User not found
  }

  // Check if the password matches
  const validPassword = await bcrypt.compare(password, user.passwordHash);
  return validPassword ? user : false;
};

module.exports = {
  createUser,
  validateCredentials
};
