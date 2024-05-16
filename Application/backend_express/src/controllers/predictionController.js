const predictionService = require("../services/internal/predictionService");
const ApiResponse = require("../responses/apiResponse");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getPrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.getPredictionById(
      predictionId,
      userId
    );
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGet,
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
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGetAll,
    });
  }
};

const createPrediction = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const imageBuffer = req.file.buffer;

    const result = await predictionService.createPrediction(
      userId,
      imageBuffer
    );
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorCreate,
    });
  }
};

const updatePredictionUser = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await predictionService.updatePredictionUser(
      predictionId,
      userId,
      updatePayload
    );
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorUpdate,
    });
  }
};

const updatePredictionWorker = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;
    const workerUpdatePayload = req.body;

    const result = await predictionService.updatePredictionWorker(
      predictionId,
      userId,
      workerUpdatePayload
    );
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorUpdate,
    });
  }
};

const deletePrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.deletePrediction(
      predictionId,
      userId
    );
    ApiResponse.handleResponse(res, result);

  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorDelete,
    });
  }
};

module.exports = {
  getPrediction,
  getAllPredictions,
  createPrediction,
  updatePredictionUser,
  updatePredictionWorker,
  deletePrediction,
};