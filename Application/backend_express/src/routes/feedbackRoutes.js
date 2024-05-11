const express = require('express');
const { checkAccessToken } = require('../middlewares/authMiddleware');
const { feedbackCreateValidator } = require('../request-validators/feedbackValidator');
const feedbackController = require('../controllers/feedbackController');

// Create a new router for the appointment routes
const router = express.Router();

router.use(checkAccessToken);
router.post('/', feedbackCreateValidator, feedbackController.createFeedback);

module.exports = router;
