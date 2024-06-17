const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema(
  {
    conversationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Conversation",
      required: [true, "Conversation ID is required"],
    },
    sender: {
      type: String,
      required: [true, "Sender of the message is required"],
      enum: ["user", "assistant"],
    },
    messageContent: {
      type: String,
      required: [true, "Message content is required"],
      trim: true,
      minlength: [1, "The message must be at least 1 character long"],
      maxlength: [10000, "The message can be no more than 1000 characters long"],
    },
  },
  {
    collection: "messages",
    timestamps: true,
  }
);

const Message = mongoose.model("Message", messageSchema);

module.exports = Message;
