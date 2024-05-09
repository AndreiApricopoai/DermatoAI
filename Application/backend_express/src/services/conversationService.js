const Conversation = require("../models/conversationModel");
const Message = require("../models/messageModel");
const mongoose = require("mongoose");

const getConversationById = async (conversationId, userId) => {
  try {
    const conversation = await Conversation.findOne(
      { _id: conversationId, userId },
      "_id title"
    ).exec();

    if (!conversation) {
      return {
        type: "error",
        status: 404,
        error: "Conversation not found.",
      };
    }

    return {
      type: "success",
      status: 200,
      data: {
        id: conversation._id.toString(),
        title: conversation.title,
      },
    };
  } catch (error) {
    console.error("Error retrieving conversation:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve conversation.",
    };
  }
};

const getAllConversationsByUserId = async (userId) => {
  try {
    const conversations = await Conversation.find({ userId })
      .select("_id title")
      .sort({ createdAt: 1 })
      .exec();

    const formattedConversations = conversations.map((convo) => ({
      id: convo._id.toString(),
      title: convo.title,
    }));

    return {
      type: "success",
      status: 200,
      data: formattedConversations,
    };
  } catch (error) {
    console.error("Error retrieving all conversations:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve all conversations.",
    };
  }
};

const createConversation = async (userId, payload) => {
  try {
    const { title } = payload;
    const newConversation = new Conversation({ userId, title });
    await newConversation.save();

    return {
      type: "success",
      status: 201,
      data: {
        id: newConversation._id.toString(),
        title: newConversation.title,
      },
    };
  } catch (error) {
    console.error("Error creating conversation:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to create a new conversation.",
    };
  }
};

const updateConversation = async (conversationId, userId, updatePayload) => {
  try {
    const conversation = await Conversation.findOne(
      { _id: conversationId, userId },
      "_id title"
    ).exec();

    if (!conversation) {
      return {
        type: "error",
        status: 404,
        error: "Conversation not found.",
      };
    }

    Object.keys(updatePayload).forEach((key) => {
      if (key in conversation) {
        conversation[key] = updatePayload[key];
      }
    });

    await conversation.save();

    return {
      type: "success",
      status: 200,
      data: {
        id: conversation._id.toString(),
        title: conversation.title,
      },
    };
  } catch (error) {
    console.error("Error updating conversation:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to update the conversation.",
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
        type: "error",
        status: 404,
        error: "Conversation not found for deletion.",
      };
    }

    await Message.deleteMany({ conversationId }).session(session);
    await session.commitTransaction();
    session.endSession();

    return {
      type: "success",
      status: 204,
    };
  } catch (error) {
    console.error("Error deleting conversation and messages:", error);

    await session.abortTransaction();
    session.endSession();
    return {
      type: "error",
      status: 500,
      error: "Failed to delete conversation and the associated messages.",
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
