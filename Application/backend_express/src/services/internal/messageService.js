const Message = require("../../models/messageModel");
const Conversation = require("../../models/conversationModel");
const mongoose = require("mongoose");
const { getOpenAIResponse } = require("../external/openaiService");
const { dermatologicalChat } = require("../../utils/constants");
const { 
  ErrorMessages,
  StatusCodes,
  ResponseTypes 
} = require("../../responses/apiConstants");

const getAllMessagesByConversationId = async (conversationId, userId, page, limit) => {
  try {
    const conversationExists = await Conversation.findOne({
      _id: conversationId,
      userId,
    }).exec();

    if (!conversationExists) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound
      };
    }

    const query = Message.find({ conversationId });
    query.sort({ createdAt: -1 });

    if (limit > 0) {
      const skip = (page - 1) * limit;
      query.skip(skip).limit(limit);
    }
    const messages = await query.exec();

    const formattedMessages = messages.map(message => ({
      id: message._id,
      sender: message.sender,
      content: message.messageContent
    }));

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: formattedMessages,
    };
  } catch (error) {
    console.error("Error retrieving messages:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError
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
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound
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
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: ErrorMessages.FetchError
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
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: {
        userMessage: {
          id: userMessage._id,
          content: userMessage.messageContent
        },
        assistantMessage: {
          id: assistantMessage._id,
          content: assistantMessage.messageContent
        },
      },
    };
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    console.error("Error adding message to conversation:", error);

    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError
    };
  }
};

module.exports = {
  getAllMessagesByConversationId,
  addMessageToConversation,
};