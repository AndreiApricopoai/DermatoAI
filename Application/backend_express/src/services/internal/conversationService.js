const Conversation = require("../../models/conversationModel");
const Message = require("../../models/messageModel");
const User = require("../../models/userModel");
const mongoose = require("mongoose");
const {
  ErrorMessages,
  StatusCodes,
  ResponseTypes,
  UserMessages,
} = require("../../responses/apiConstants");

const getConversationById = async (conversationId, userId) => {
  try {
    const conversation = await Conversation.findOne({
      _id: conversationId,
      userId,
    }).exec();

    if (!conversation) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    responseData = {
      id: conversation._id,
      title: conversation.title,
      createdAt: conversation.createdAt,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseData,
    };
  } catch (error) {
    console.error("Error retrieving conversation:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const getAllConversationsByUserId = async (userId) => {
  try {
    const conversations = await Conversation.find({ userId })
      .select("_id title createdAt")
      .sort({ createdAt: -1 })
      .exec();

    const formattedConversations = conversations.map((convo) => ({
      id: convo._id,
      title: convo.title,
      createdAt: convo.createdAt,
    }));

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: formattedConversations,
    };
  } catch (error) {
    console.error("Error retrieving all conversations:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const createConversation = async (userId, payload) => {
  try {
    const existsUser = await User.findOne({ _id: userId }).exec();
    if (!existsUser) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound,
      };
    }

    const { title } = payload;
    const newConversation = new Conversation({ userId, title });
    await newConversation.save();

    const responseData = {
      id: newConversation._id.toString(),
      title: newConversation.title,
      createdAt: newConversation.createdAt,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Created,
      data: responseData,
    };
  } catch (error) {
    console.error("Error creating conversation:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const updateConversation = async (conversationId, userId, updatePayload) => {
  try {
    const conversation = await Conversation.findOne({
      _id: conversationId,
      userId,
    }).exec();

    if (!conversation) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    Object.keys(updatePayload).forEach((key) => {
      conversation[key] = updatePayload[key];
    });
    await conversation.save();

    const updatedConversationData = {
      id: conversation._id,
      title: conversation.title,
      createdAt: conversation.createdAt,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: updatedConversationData,
    };
  } catch (error) {
    console.error("Error updating conversation:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const deleteConversation = async (conversationId, userId) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const result = await Conversation.deleteOne({
      _id: conversationId,
      userId,
    }).session(session);

    if (result.deletedCount === 0) {
      await session.abortTransaction();
      session.endSession();
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    await Message.deleteMany({ conversationId }).session(session);
    await session.commitTransaction();
    session.endSession();

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
    };
  } catch (error) {
    console.error("Error deleting conversation and messages:", error);

    await session.abortTransaction();
    session.endSession();
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

module.exports = {
  getConversationById,
  getAllConversationsByUserId,
  createConversation,
  updateConversation,
  deleteConversation,
};
