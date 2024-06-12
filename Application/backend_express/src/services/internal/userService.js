const User = require("../../models/userModel");
const {
  StatusCodes,
  ResponseTypes,
  UserMessages,
} = require("../../responses/apiConstants");

const getProfileInformation = async (userId) => {
  try {
    const user = await User.findOne({ _id: userId }).exec();

    if (!user) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound,
      };
    }

    const responseData = {
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      profilePhoto: user.profilePhoto,
      verified: user.verified,
      isGoogleUser: user.googleId ? true : false,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseData,
    };
  } catch (error) {
    console.error("Error retrieving user:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: UserMessages.FailedRetrieve,
    };
  }
};

const getVerifiedStatus = async (userId) => {
  try {
    const user = await User.findOne({ _id: userId }).exec();

    if (!user) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound,
      };
    }

    const responseData = {
      verified: user.verified,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseData,
    };
  } catch (error) {
    console.error("Error retrieving user:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: UserMessages.FailedRetrieve,
    };
  }
};

module.exports = {
  getProfileInformation,
  getVerifiedStatus,
};
