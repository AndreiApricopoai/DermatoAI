const mongoose = require("mongoose");

const feedbackSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
    },
    category: {
      type: String,
      required: [true, "Feedback category is required"],
      enum: ["app", "bugs", "usability", "predictions", "AIchat", "other"],
    },
    content: {
      type: String,
      required: [true, "Feedback content is required"],
      minlength: [10, "Feedback needs to be at least 10 characters long"],
      maxlength: [1000, "Feedback can be no more than 1000 characters long"],
    },
  },
  {
    collection: "feedbacks",
    timestamps: true,
  }
);

const Feedback = mongoose.model("Feedback", feedbackSchema);

module.exports = Feedback;