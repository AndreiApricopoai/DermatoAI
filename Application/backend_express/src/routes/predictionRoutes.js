const express = require("express");
const validateImage = require("../request-validators/imageUploadValidator");
const {
  checkAccessToken,
  checkWorkerToken,
} = require("../middlewares/authMiddleware");
const { handleMulterUpload } = require("../middlewares/imageUploadMiddleware");
const { validateParamId } = require("../middlewares/mongooseMiddleware");
const {
  updateUserPredictionValidator,
  updateWorkerPredictionValidator,
} = require("../request-validators/predictionValidator");
const predictionController = require("../controllers/predictionController");
const upload = require("../config/imageUploadConfig");

const router = express.Router();

router.get(
  "/:id",
  checkAccessToken,
  validateParamId,
  predictionController.getPrediction
);
router.get("/", checkAccessToken, predictionController.getAllPredictions);
router.post(
  "/",
  checkAccessToken,
  upload.single("image"),
  handleMulterUpload,
  validateImage,
  predictionController.createPrediction
);
router.patch(
  "/:id",
  checkAccessToken,
  validateParamId,
  updateUserPredictionValidator,
  predictionController.updatePredictionUser
);
router.patch(
  "/worker-updates/:id",
  checkWorkerToken,
  validateParamId,
  updateWorkerPredictionValidator,
  predictionController.updatePredictionWorker
);
router.delete(
  "/:id",
  checkAccessToken,
  validateParamId,
  predictionController.deletePrediction
);

module.exports = router;
