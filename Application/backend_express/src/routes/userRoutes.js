const express = require('express');
const authMiddleware = require('../middlewares/authMiddleware');
const router = express.Router();
const userController = require('../controllers/userController');

// Register route
router.post('/register', userController.registerUser);

//use the middleware for all routes that require authentication
router.use(authMiddleware);


module.exports = router;