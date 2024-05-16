const Feedback = require("../../models/feedbackModel");
const User = require("../../models/userModel");
const { 
  ErrorMessages,
  StatusCodes,
  ResponseTypes,
  UserMessages 
} = require("../../responses/apiConstants");

const createFeedback = async (userId, payload) => {
  try {
    const existsUser = await User.findOne({ _id: userId }).exec();
    if (!existsUser) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound
      };
    }

    const { category, content } = payload;
    const newFeedback = new Feedback({ userId, category, content });
    await newFeedback.save();

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Created
    };
  } catch (error) {
    console.error("Error creating feedback:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError
    };
  }
};

module.exports = {
  createFeedback
};