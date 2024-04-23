const express = require('express');
const passport = require('passport');
const router = express.Router();
const authController = require('../controllers/authController');
const { loginValidator, registerValidator } = require('../frontend-validators/authValidator');
const { checkAccessToken, checkRefreshToken} = require('../middlewares/authMiddleware');

// DermatoAI account routes
router.post('/login', loginValidator, authController.login);
router.post('/register', registerValidator, authController.register);

// Google account routes
router.get('/google/login',
  passport.authenticate('google-login', { scope: ['profile', 'email'] })
);
router.get('/google/login/callback',
  passport.authenticate('google-login', { session: false }),
  authController.googleCallback
);
router.get('/google/register',
  passport.authenticate('google-register', { scope: ['profile', 'email'] })
);
router.get('/google/register/callback',
  passport.authenticate('google-register', { session: false }),
  authController.googleCallback
);

// Logout both DermatoAI and Google accounts
router.delete('/logout', checkAccessToken, checkRefreshToken, authController.logout);

// Get a new access token based on the refresh token
router.post('/token', checkRefreshToken, authController.getAccesToken);

module.exports = router;