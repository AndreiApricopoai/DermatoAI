const express = require("express");
const { checkAccessToken } = require("../middlewares/authMiddleware");
const {
  createFeedbackValidator,
} = require("../request-validators/feedbackValidator");
const feedbackController = require("../controllers/feedbackController");

const router = express.Router();
router.use(checkAccessToken);

router.post("/", createFeedbackValidator, feedbackController.createFeedback);

module.exports = router;