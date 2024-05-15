const predictionService = require('../services/internal/predictionService');
const ApiResponse = require('../responses/apiResponse');
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getPrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.getPredictionById(userId, predictionId);
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction retrieval. Please try again later.'
    });
  }
};

const getAllPredictions = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await predictionService.getAllPredictionsByUserId(userId);
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during predictions retrieval. Please try again later.'
    });
  }
};

const createPrediction = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const imageBuffer = req.file.buffer;

    const result = await predictionService.createPrediction(userId, imageBuffer);
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during image processing. Please try again later.'
    });
  }
};

const updatePredictionUser = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await predictionService.updatePredictionUser(predictionId, userId, updatePayload);
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction update. Please try again later.'
    });
  }
}

const updatePredictionWorker = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;
    const workerUpdatePayload = req.body;

    const result = await predictionService.updatePredictionWorker(predictionId, userId, workerUpdatePayload);
    ApiResponse.handleResponse(res, result);


  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction update. Please try again later.'
    });
  }
};

const deletePrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.deletePrediction(predictionId, userId);
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction deletion. Please try again later.'
    });
  }
};

module.exports = {
  getPrediction,
  getAllPredictions,
  createPrediction,
  updatePredictionUser,
  updatePredictionWorker,
  deletePrediction
};