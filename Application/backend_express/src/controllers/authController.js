require("dotenv").config();
const ApiResponse = require("../responses/apiResponse");
const authService = require("../services/internal/authService");
const { getGoogleAuthRedirectUrl } = require("../utils/constants");
const {
  StatusCodes,
  AuthMessages,
  GoogleMessages,
} = require("../responses/apiConstants");

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const payload = { email, password };

    const result = await authService.login(payload);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorLogin,
    });
  }
};

const register = async (req, res) => {
  try {
    const { firstName, lastName, email, password, confirmPassword } = req.body;
    const payload = { firstName, lastName, email, password, confirmPassword };

    const result = await authService.register(payload);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorRegister,
    });
  }
};

const googleCallback = async (req, res) => {
  try {
    if (req.user.isSuccess !== undefined) {
      const response = {
        isSuccess: false,
        message: "Server error",
        apiResponseCode: 2,
        error: GoogleMessages.AuthFailed,
      };
      const responsePage = getGoogleAuthRedirectUrl(response);
      res.send(responsePage);
    } else {
      const { _id, firstName, lastName } = req.user;
      const payload = { _id, firstName, lastName };

      const result = await authService.handleGoogleCallback(payload);
      const responsePage = getGoogleAuthRedirectUrl(result);
      res.send(responsePage);
    }
  } catch (error) {
    console.error("Google authentication error.", error);
    const response = {
      isSuccess: false,
      message: "Server error",
      apiResponseCode: 2,
      error: GoogleMessages.Error,
    };
    const responsePage = getGoogleAuthRedirectUrl(response);
    res.send(responsePage);
  }
};

const logout = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const refreshToken = req.body.refreshToken;

    const result = await authService.logout(userId, refreshToken);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorLogout,
    });
  }
};

const getAccessToken = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const refreshToken = req.body.refreshToken;

    const result = await authService.getAccessToken(userId, refreshToken);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorGetAccessToken,
    });
  }
};

const sendVerificationEmail = async (req, res) => {
  try {
    const email = req.body.email;

    const result = await authService.sendVerificationEmail(email);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorSendVerificationEmail,
    });
  }
};

const verifyEmail = async (req, res) => {
  try {
    const verificationToken = req.query.token;
    const result = await authService.verifyEmail(verificationToken);

    if (result.type === "success") {
      res.redirect("/email-verification-succes.html");
    } else {
      res.redirect("/email-verification-failure.html");
    }
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorVerifyEmail,
    });
  }
};

const changePassword = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const { oldPassword, password } = req.body;
    const payload = { oldPassword, password };

    const result = await authService.changePassword(userId, payload);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorPasswordChange,
    });
  }
};

const sendForgotPasswordEmail = async (req, res) => {
  try {
    const email = req.body.email;

    const result = await authService.sendForgotPasswordEmail(email);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorForgotPassword,
    });
  }
};

const resetPassword = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const { forgotPasswordToken, password } = req.body;
    const payload = { forgotPasswordToken, password };

    const result = await authService.resetPassword(userId, payload);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: AuthMessages.UnexpectedErrorResetPassword,
    });
  }
};

module.exports = {
  register,
  login,
  googleCallback,
  logout,
  getAccessToken,
  sendVerificationEmail,
  verifyEmail,
  changePassword,
  sendForgotPasswordEmail,
  resetPassword,
};
