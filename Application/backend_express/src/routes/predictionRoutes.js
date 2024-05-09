const express = require('express');
const validateImage = require('../request-validators/imageUploadValidator');
const { checkAccessToken, checkWorkerToken } = require('../middlewares/authMiddleware');
const { handleMulterUpload } = require('../middlewares/predictionMiddleware');
const predictionController = require('../controllers/predictionController');
const upload = require('../config/imageUploadConfig');

// Create a new router for the prediction routes
const router = express.Router();

router.post('/', upload.single('image'), handleMulterUpload, checkAccessToken, validateImage, predictionController.createPrediction);
router.patch('/:id', checkAccessToken, predictionController.updatePredictionUser);
router.patch('worker-updates/:id', checkWorkerToken, predictionController.updatePredictionWorker);

module.exports = router;