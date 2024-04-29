const express = require('express');
const validateImage = require('../request-validators/imageUploadValidator');
const { checkAccessToken } = require('../middlewares/authMiddleware');
const { handleMulterUpload } = require('../middlewares/predictionMiddleware');
const predictionController = require('../controllers/predictionController');
const upload = require('../config/imageUploadConfig');
const router = express.Router();

router.post('/', upload.single('image'), handleMulterUpload, checkAccessToken, validateImage, predictionController.createPrediction);

module.exports = router;