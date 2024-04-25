const express = require('express');
const router = express.Router();
const predictionsController = require('../controllers/predictionController');
const upload = require('../config/imageUploadConfig');
const validateImage = require('../request-validators/imageUploadValidator');

router.post('/', upload.single('image'), validateImage, predictionsController.createPrediction);

module.exports = router;
