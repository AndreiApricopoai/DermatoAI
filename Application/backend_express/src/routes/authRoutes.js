const express = require("express");
const passport = require("../config/passportConfig");
const authController = require("../controllers/authController");
const {
  loginValidator,
  registerValidator,
  googleAuthValidator,
  getAccesTokenValidator,
  emailValidator,
  changePasswordValidator,
  resetPasswordValidator,
} = require("../request-validators/authValidator");
const {
  checkAccessToken,
  checkRefreshToken,
  checkEmailVerificationToken,
  checkForgotPasswordToken,
} = require("../middlewares/authMiddleware");

const router = express.Router();

// DermatoAI account routes
router.post("/login", loginValidator, authController.login);
router.post("/register", registerValidator, authController.register);

// Google account routes
router.get(
  "/google/login",
  passport.authenticate("google-login", { scope: ["profile", "email"] })
);
router.get(
  "/google/login/callback",
  passport.authenticate("google-login", { session: false }),
  googleAuthValidator,
  authController.googleCallback
);
router.get(
  "/google/register",
  passport.authenticate("google-register", { scope: ["profile", "email"] })
);
router.get(
  "/google/register/callback",
  passport.authenticate("google-register", { session: false }),
  googleAuthValidator,
  authController.googleCallback
);

// Logout both DermatoAI and Google accounts
router.delete(
  "/logout",
  checkAccessToken,
  checkRefreshToken,
  authController.logout
);

// Get a new access token based on the refresh token
router.get(
  "/token",
  getAccesTokenValidator,
  checkRefreshToken,
  authController.getAccessToken
);

// Email verification routes
router.post(
  "/send-verification-email",
  checkAccessToken,
  emailValidator,
  authController.sendVerificationEmail
);
router.get(
  "/verify-email",
  checkEmailVerificationToken,
  authController.verifyEmail
);

// Change password routes
router.post(
  "/change-password",
  checkAccessToken,
  changePasswordValidator,
  authController.changePassword
);

// Forgot password routes
router.post(
  "/send-forgot-password-email",
  emailValidator,
  authController.sendForgotPasswordEmail
);
router.post(
  "/reset-password",
  checkForgotPasswordToken,
  resetPasswordValidator,
  authController.resetPassword
);

module.exports = router;
