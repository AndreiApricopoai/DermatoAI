const express = require('express');
const validateImage = require('../request-validators/imageUploadValidator');
const { checkAccessToken } = require('../middlewares/authMiddleware');
const predictionController = require('../controllers/predictionController');
const upload = require('../config/imageUploadConfig');
const router = express.Router();

router.post('/', upload.single('image'), checkAccessToken, validateImage, predictionController.createPrediction);

module.exports = router;