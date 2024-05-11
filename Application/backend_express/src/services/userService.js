const User = require("../models/userModel");

const getProfileInformation = async (userId) => {
  try {

    const user = await User.findOne({ _id: userId }).exec();

    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found.",
      };
    }

    const responseData = {
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      profilePhoto: user.profilePhoto,
      verified: user.verified
    };

    return {
      type: "success",
      status: 200,
      data: responseData,
    };

  } catch (error) {
    console.error("Error retrieving user:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve user.",
    };
  }
};

const getVerifiedStatus = async (userId) => {
  try {
      const user = await User.findOne({ _id: userId }).exec();

      if (!user) {
          return {
              type: "error",
              status: 404,
              error: "User not found.",
          };
      }

      const responseData = {
          verified: user.verified,
      };

      return {
          type: "success",
          status: 200,
          data: responseData,
      };

  } catch (error) {
      console.error("Error retrieving user:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve user.",
    };
  }
};

module.exports = {
  getProfileInformation,
  getVerifiedStatus
};
