const mongoose = require("mongoose");

const conversationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
    },
    title: {
      type: String,
      required: [true, "Title is required"],
      default: "Untitled",
      trim: true,
      minlength: [1, "Title must be at least 1 character long"],
      maxlength: [100, "Title can be no more than 100 characters long"],
    },
  },
  {
    collection: "conversations",
    timestamps: true,
  }
);

const Conversation = mongoose.model("Conversation", conversationSchema);

module.exports = Conversation;
