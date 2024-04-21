// src/routes/userRoutes.js

const express = require('express');
const passport = require('passport');
const authController = require('../controllers/authController');
const router = express.Router();

// Get a new token using refresh token
router.post('/token', authController.getToken);

// Standard account routes
router.post('/register', authController.register);
router.post('/login', authController.login);




router.get('/google/login',
  passport.authenticate('google-login', { scope: ['profile', 'email'] })
);

router.get('/google/login/callback',
  passport.authenticate('google-login', { session: false }),
  authController.googleAuthCallback
);

router.get('/google/register',
  passport.authenticate('google-register', { scope: ['profile', 'email'] })
);

router.get('/google/register/callback',
  passport.authenticate('google-register', { session: false }),
  authController.googleAuthCallback
);




//google callback route
//router.get('/google/callback', authController.googleCallback);

// Log out route
router.delete('/logout', authController.logout);

module.exports = router;
