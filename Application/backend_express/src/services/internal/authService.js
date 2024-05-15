require("dotenv").config();
const User = require("../../models/userModel");
const RefreshToken = require("../../models/refreshTokenModel");
const emailService = require("../external/emailService");
const { VERIFICATION_URL, getVerificationEmailHtml, getResetPasswordEmailHtml } = require("../../utils/constants");
const {
  createJwtToken,
  extractPayloadJwt,
  getTokenHash,
  isValidJwt,
} = require("../../utils/authUtils");

// Login function for DermatoAI account
const login = async (payload) => {
  try {
    const email = payload.email.toLowerCase();
    const password = payload.password;
    const user = await User.findOne({ email: email }).exec();

    if (!user) {
      return {
        type: "error",
        status: 400,
        error: "User with this email does not exist.",
      };
    }

    if (user.googleId) {
      return {
        type: "error",
        status: 400,
        error: "User with this email exists. Please login with Google.",
      };
    }

    const passwordValid = await user.validatePassword(password);
    if (!passwordValid) {
      return {
        type: "error",
        status: 400,
        error: "Invalid password.",
      };
    }

    const tokenPayload = {
      userId: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
    };

    const token = createJwtToken(
      process.env.ACCESS_TOKEN_SECRET,
      "15m",
      tokenPayload
    );
    const refreshToken = createJwtToken(
      process.env.REFRESH_TOKEN_SECRET,
      "7d",
      tokenPayload
    );

    if (!token || !refreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating the tokens.",
      };
    }

    const saveRefreshToken = await saveRefreshTokenToCollection(
      refreshToken,
      user._id
    );

    if (!saveRefreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while saving the refresh token.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        message: "Login successful.",
        token,
        refreshToken,
      },
    };
  } catch (error) {
    console.error("Login service error:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during login. Please try again later.",
    };
  }
};

// Register function for DermatoAI account
const register = async (payload) => {
  try {
    const { firstName, lastName, email, password } = payload;
    const userExists = await User.findOne({
      email: email.toLowerCase(),
    }).exec();

    if (userExists) {
      return {
        type: "error",
        status: 400,
        error: "User with this email already exists.",
      };
    }

    const user = new User({
      firstName,
      lastName,
      email: email.toLowerCase(),
      passwordHash: password,
    });

    const tokenPayload = {
      userId: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
    };

    const token = createJwtToken(
      process.env.ACCESS_TOKEN_SECRET,
      "15m",
      tokenPayload
    );
    const refreshToken = createJwtToken(
      process.env.REFRESH_TOKEN_SECRET,
      "7d",
      tokenPayload
    );

    if (!token || !refreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating the tokens.",
      };
    }

    const saveRefreshToken = await saveRefreshTokenToCollection(
      refreshToken,
      user._id
    );

    if (!saveRefreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while saving the refresh token.",
      };
    }

    await user.save();

    const sendVerificationResult = await sendVerificationEmail(user.email);

    return {
      type: "success",
      status: 200,
      data: {
        message: "Registration successful.",
        sentVerification:
          sendVerificationResult.type === "success" ? true : false,
        token,
        refreshToken,
      },
    };
  } catch (error) {
    console.error("Register service error:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during registration. Please try again later.",
    };
  }
};

// Google OAuth callback function
const handleGoogleCallback = async (payload) => {
  try {
    const { _id, firstName, lastName } = payload;
    const tokenPayload = {
      userId: _id,
      firstName: firstName,
      lastName: lastName,
    };

    const token = createJwtToken(
      process.env.ACCESS_TOKEN_SECRET,
      "15m",
      tokenPayload
    );
    const refreshToken = createJwtToken(
      process.env.REFRESH_TOKEN_SECRET,
      "7d",
      tokenPayload
    );

    if (!token || !refreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating the tokens.",
      };
    }

    const saveRefreshToken = await saveRefreshTokenToCollection(refreshToken, _id);

    if (!saveRefreshToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while saving the refresh token.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        message: "Google authentication successful.",
        token,
        refreshToken,
      },
    };
  } catch (error) {
    console.error("Google authentication service error.", error);
    return {
      type: "error",
      status: 500,
      error:
        "An error occurred while trying to authenticate using Google. Please try again later.",
    };
  }
};

// Logout function from both DermatoAI and Google accounts
const logout = async (userId, refreshToken) => {
  try {
    const refreshTokenHash = getTokenHash(refreshToken);
    const result = await RefreshToken.findOneAndDelete({
      user: userId,
      tokenHash: refreshTokenHash,
    }).exec();

    if (!refreshTokenHash || !result) {
      return {
        type: "error",
        status: 404,
        error: "No token found. Perhaps the user is already logged out.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: { message: "Logged out successfully." },
    };

  } catch (error) {
    console.error("Error during logout:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during logout. Please try again later.",
    };
  }
};

// Get a new access token using a refresh token
const getAccessToken = async (userId, refreshToken) => {
  try {
    const refreshTokenHash = getTokenHash(refreshToken);
    const existsRefreshToken = await RefreshToken.findOne({
      user: userId,
      tokenHash: refreshTokenHash,
    }).exec();

    if (!refreshTokenHash || !existsRefreshToken) {
      return {
        type: "error",
        status: 404,
        error: "Refresh token not found.",
      };
    }

    if (existsRefreshToken.expires < new Date()) {
      await RefreshToken.findByIdAndDelete(existsRefreshToken._id).exec();
      return {
        type: "error",
        status: 401,
        error: "Refresh token has expired.",
      };
    }

    const extracted = extractPayloadJwt(refreshToken);

    if (!extracted) {
      return {
        type: "error",
        status: 401,
        error: "Token payload could not be extracted.",
      };
    }

    const newAccessTokenPayload = {
      userId: extracted.userId,
      firstName: extracted.firstName,
      lastName: extracted.lastName,
    };

    const newAccessToken = createJwtToken(
      process.env.ACCESS_TOKEN_SECRET,
      "15m",
      newAccessTokenPayload
    );

    if (!newAccessToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating a new acces token.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        message: "New access token generated successfully.",
        token: newAccessToken,
      },
    };

  } catch (error) {
    console.error("Error during new access token generation:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during access token retrieval. Please try again later.",
    };
  }
};

const sendVerificationEmail = async (email) => {
  try {
    const user = await User.findOne({ email }).exec();

    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found for this email address.",
      };
    }

    if (user.verified) {
      return {
        type: "error",
        status: 400,
        error: "User is already verified.",
      };
    }

    const tokenPayload = {
      userId: user._id,
      email: user.email,
    };

    const verificationToken = createJwtToken(
      process.env.VERIFICATION_TOKEN_SECRET,
      "24h",
      tokenPayload
    );

    if (!verificationToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating the verification token.",
      };
    }

    const verificationUrl = VERIFICATION_URL + verificationToken;
    const html = getVerificationEmailHtml(verificationUrl);

    const sendResult = await emailService.sendEmail(
      email,
      "Verify Your Email",
      html
    );

    if (!sendResult) {
      return {
        type: "error",
        status: 500,
        error: "Failed to send verification email.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        message: "Verification email sent successfully.",
      },
    };
  } catch (error) {
    console.error("Failed to send verification email:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during email verification. Please try again later.",
    };
  }
};

const verifyEmail = async (verificationToken) => {
  try {
    const secretKey = process.env.VERIFICATION_TOKEN_SECRET;

    if (!isValidJwt(verificationToken, secretKey)) {
      return {
        type: "error",
        status: 400,
        error: "Invalid verification token or expired.",
      };
    }

    const tokenPayload = extractPayloadJwt(verificationToken);
    if (!tokenPayload) {
      return {
        type: "error",
        status: 400,
        error: "Invalid token payload.",
      };
    }

    const { userId, email } = payload;
    const user = await User.findOne({ _id: userId }).exec();
    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found for this email address.",
      };
    }

    if (user.verified) {
      return {
        type: "error",
        status: 400,
        error: "User is already verified.",
      };
    }

    if (user.email !== email) {
      return {
        type: "error",
        status: 400,
        error: "Invalid email address.",
      };
    }

    user.verified = true;
    await user.save();

    return {
      type: "success",
      status: 200,
      data: {
        message: "Email verified successfully.",
      },
    };
  } catch (error) {
    console.error("Error verifying email:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during email verification. Please try again later.",
    };
  }
};


const changePassword = async (userId, payload) => {
  try {
    const { oldPassword, password } = payload;
    const user = await User.findOne({ _id: userId }).exec();
    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found.",
      };
    }

    if (user.googleId) {
      return {
        type: "error",
        status: 400,
        error:
          "User with this email exists. Please change password from Google.",
      };
    }

    const oldPasswordValid = await user.validatePassword(oldPassword);
    if (!oldPasswordValid) {
      return {
        type: "error",
        status: 400,
        error: "Invalid old password.",
      };
    }

    user.passwordHash = password;
    await user.save();

    return {
      type: "success",
      status: 200,
      data: {
        message: "Password changed successfully.",
      },
    };
  } catch (error) {
    console.error("Error changing password:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during password change. Please try again later.",
    };
  }
};

const sendForgotPasswordEmail = async (email) => {
  try {
    const user = await User.findOne({ email }).exec();
    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found for this email address.",
      };
    }

    if (user.googleId) {
      return {
        type: "error",
        status: 400,
        error:
          "User with this email exists. Please reset password from Google.",
      };
    }

    const tokenPayload = {
      userId: user._id,
      email: user.email,
    };

    const forgotPasswordToken = createJwtToken(
      process.env.FORGOT_PASSWORD_TOKEN_SECRET,
      "24h",
      tokenPayload
    );

    if (!forgotPasswordToken) {
      return {
        type: "error",
        status: 500,
        error: "An error occurred while creating the forgot password token.",
      };
    }

    const html = getResetPasswordEmailHtml(forgotPasswordToken);

    const sendResult = await emailService.sendEmail(
      email,
      "Reset Your Password",
      html
    );

    if (!sendResult) {
      return {
        type: "error",
        status: 500,
        error: "Failed to send forgot password email.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        message: "Forgot password email sent successfully.",
      }
    };

  } catch (error) {
    console.error("Failed to send forgot password email:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during forgot password email. Please try again later.",
    };
  }
};

const resetPassword = async (userId, payload) => {
  try {
    const { forgotPasswordToken, password } = payload;
    const user = await User.findOne({ _id: userId }).exec();
    
    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found.",
      };
    }

    if (user.googleId) {
      return {
        type: "error",
        status: 400,
        error:
          "User with this email exists. Please reset password from Google.",
      };
    }

    const secretKey = process.env.FORGOT_PASSWORD_TOKEN_SECRET;

    if (!isValidJwt(forgotPasswordToken, secretKey)) {
      return {
        type: "error",
        status: 400,
        error: "Invalid forgot password token or expired.",
      };
    }

    const tokenPayload = extractPayloadJwt(forgotPasswordToken);
    if (!tokenPayload) {
      return {
        type: "error",
        status: 400,
        error: "Invalid token payload.",
      };
    }

    if (tokenPayload.userId !== userId) {
      return {
        type: "error",
        status: 400,
        error: "Invalid user ID.",
      };
    }

    user.passwordHash = password;
    await user.save();

    return {
      type: "success",
      status: 200,
      data: {
        message: "Password reset successfully.",
      },
    };
  } catch (error) {
    console.error("Error resetting password:", error);
    return {
      type: "error",
      status: 500,
      error:
        "An unexpected error occurred during password reset. Please try again later.",
    };
  }
};

// PRIVATE helper function to create a refresh token in the database
const saveRefreshTokenToCollection = async (refreshToken, userId) => {
  const expirationDate = new Date();
  expirationDate.setDate(expirationDate.getDate() + 7); // 7 days in the future

  const hash = getTokenHash(refreshToken);
  if (!hash) {
    console.error("Error creating token hash.");
    return false;
  }

  await new RefreshToken({
    user: userId,
    tokenHash: hash,
    expires: expirationDate,
  }).save();

  return true;
};

module.exports = {
  login,
  register,
  logout,
  getAccessToken,
  handleGoogleCallback,
  sendVerificationEmail,
  verifyEmail,
  changePassword,
  sendForgotPasswordEmail,
  resetPassword,
};
