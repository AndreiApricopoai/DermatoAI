const Feedback = require("../../models/feedbackModel");
const User = require("../../models/userModel");

const createFeedback = async (userId, payload) => {
  try {
    const user = await User.findOne({ _id: userId }).exec();

    if (!user) {
      return {
        type: "error",
        status: 404,
        error: "User not found.",
      };
    }

    const { category, content } = payload;

    const newFeedback = new Feedback({ userId, category, content });
    await newFeedback.save();

    return {
      type: "success",
      status: 201,
      data: {
        message: "Feedback sent successfully.",
      },
    };
  } catch (error) {
    console.error("Error creating feedback:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to sent the feedback.",
    };
  }
};

module.exports = {
  createFeedback
};
