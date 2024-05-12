const express = require('express');
const validateImage = require('../request-validators/imageUploadValidator');
const { checkAccessToken, checkWorkerToken } = require('../middlewares/authMiddleware');
const { handleMulterUpload } = require('../middlewares/predictionMiddleware');
const { validateObjectId } = require('../middlewares/mongooseMiddleware');
const { predictionUserUpdateValidator, predictionWorkerUpdateValidator } = require('../request-validators/predictionValidator');
const predictionController = require('../controllers/predictionController');
const upload = require('../config/imageUploadConfig');

// Create a new router for the prediction routes
const router = express.Router();

router.get('/:id',checkAccessToken, validateObjectId, predictionController.getPrediction);
router.get('/', checkAccessToken, predictionController.getAllPredictions);

router.post('/', upload.single('image'), handleMulterUpload, checkAccessToken, validateImage, predictionController.createPrediction);
router.patch('/:id', predictionUserUpdateValidator, checkAccessToken, predictionController.updatePredictionUser);
router.patch('worker-updates/:id', predictionWorkerUpdateValidator, checkWorkerToken, predictionController.updatePredictionWorker);

router.delete('/:id', checkAccessToken, validateObjectId, predictionController.deletePrediction);

module.exports = router;