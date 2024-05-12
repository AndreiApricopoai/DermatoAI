const Message = require("../models/messageModel");
const Conversation = require("../models/conversationModel");
const { getOpenAIResponse } = require("../services/openaiService");
const { dermatologicalChat } = require("../utils/constants");
mongoose = require("mongoose");

const getAllMessagesByConversationId = async (conversationId, userId, page, limit) => {
  try {
    console.log("conversationId", conversationId);
    console.log("userId", userId);
    const conversationExists = await Conversation.findOne({
      _id: conversationId,
      userId,
    }).exec();

    if (!conversationExists) {
      return {
        type: "error",
        status: 404,
        error: "Conversation not found.",
      };
    }

    const query = Message.find({ conversationId });
    query.sort({ createdAt: -1 }); // Assuming newer messages should come first

    // Implement pagination only if limit is specified
    if (limit > 0) {
      const skip = (page - 1) * limit;
      query.skip(skip).limit(limit);
    }

    const messages = await query.exec();

    const formattedMessages = messages.map(message => ({
      sender: message.sender,
      content: message.messageContent,
    }));

    return {
      type: "success",
      status: 200,
      data: formattedMessages,
    };
  } catch (error) {
    console.error("Error retrieving messages:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve the messages.",
    };
  }
};

const addMessageToConversation = async (
  conversationId,
  userId,
  messageContent
) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const conversationExists = await Conversation.findOne({
      _id: conversationId,
      userId,
    }).exec();

    if (!conversationExists) {
      await session.abortTransaction();
      session.endSession();
      return {
        type: "error",
        status: 404,
        error: "Conversation not found.",
      };
    }

    const userMessage = new Message({
      conversationId,
      sender: "user",
      messageContent,
    });
    await userMessage.save({ session });

    const openaiResponse = await getOpenAIResponse(
      dermatologicalChat.model,
      dermatologicalChat.context,
      dermatologicalChat.maxTokens,
      messageContent
    );

    if (!openaiResponse) {
      await session.abortTransaction();
      session.endSession();
      return {
        type: "error",
        status: 500,
        error: "Failed to receive a valid response from the assistant.",
      };
    }

    const assistantMessage = new Message({
      conversationId,
      sender: "assistant",
      messageContent: openaiResponse,
    });
    await assistantMessage.save({ session });

    await session.commitTransaction();
    session.endSession();

    return {
      type: "success",
      status: 200,
      data: {
        userMessage: {
          id: userMessage._id,
          content: userMessage.messageContent,
        },
        assistantMessage: {
          id: assistantMessage._id,
          content: assistantMessage.messageContent,
        },
      },
    };
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    console.error("Error adding message to conversation:", error);

    return {
      type: "error",
      status: 500,
      error: "Failed to add messages to the conversation.",
    };
  }
};

module.exports = {
  getAllMessagesByConversationId,
  addMessageToConversation,
};
