const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const feedbackSchema = new Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"]
    },
    category: {
      type: String,
      required: [true, "Feedback category is required"],
      enum: ["app", "bugs", "usability", "predictions", "AIchat", "other"]
    },
    content: {
      type: String,
      required: [true, "Feedback content is required"],
      minlength: [10, "Feedback content is too short"],
      maxlength: [1000, "Feedback content is too long"]
    },
  },
  {
    collection: "feedbacks",
    timestamps: true,  }
);

const Feedback = mongoose.model("Feedback", feedbackSchema);

module.exports = Feedback;
