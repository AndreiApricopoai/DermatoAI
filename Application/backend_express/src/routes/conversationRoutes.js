const express = require("express");
const { checkAccessToken } = require("../middlewares/authMiddleware");
const {
  createConversationValidator,
  updateConversationValidator,
  addMessageValidator,
  paginationValidator,
} = require("../request-validators/conversationValidator");
const { validateParamId } = require("../middlewares/mongooseMiddleware");
const conversationController = require("../controllers/conversationController");
const messageController = require("../controllers/messageController");

const router = express.Router();
router.use(checkAccessToken);

router.get("/:id", validateParamId, conversationController.getConversation);
router.get("/", conversationController.getAllConversations);
router.post(
  "/",
  createConversationValidator,
  conversationController.createConversation
);
router.patch(
  "/:id",
  validateParamId,
  updateConversationValidator,
  conversationController.updateConversation
);
router.delete(
  "/:id",
  validateParamId,
  conversationController.deleteConversation
);

router.get(
  "/:conversationId/messages",
  validateParamId,
  paginationValidator,
  messageController.getAllMessagesFromConversation
);
router.post(
  "/:conversationId/messages",
  validateParamId,
  addMessageValidator,
  messageController.addMessageToConversation
);

module.exports = router;
