const predictionService = require('../services/predictionService');
const ApiResponse = require('../responses/apiResponse');

const createPrediction = async (req, res) => {
  try {
    if (!req.file || !req.file.buffer) {
      return ApiResponse.error(res, {
        statusCode: 400,
        error: 'No image uploaded.'
      });
    }

    const userId = req.currentUser.userId;
    const imageBuffer = req.file.buffer;

    const result = await predictionService.createPrediction(userId, imageBuffer);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to perform a valid image processing operation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during image processing. Please try again later.'
    });
  }
};

const updatePredictionUser = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;
    const diagnosisName = req.body.diagnosisName;
    const diagnosisCode = req.body.diagnosisCode;
    const diagnosisType = req.body.diagnosisType;
    const confidenceLevel = req.body.confidenceLevel;

    const result = await predictionService.updatePredictionUser(predictionId, userId, diagnosisName, diagnosisCode, diagnosisType, confidenceLevel);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to perform a valid prediction update operation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction update. Please try again later.'
    });
  }
}

const updatePredictionWorker = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const workerToken = req.headers['worker-token'];
    const diagnosisName = req.body.diagnosisName;
    const diagnosisCode = req.body.diagnosisCode;
    const diagnosisType = req.body.diagnosisType;
    const confidenceLevel = req.body.confidenceLevel;

    const result = await predictionService.updatePredictionWorker(predictionId, workerToken, diagnosisName, diagnosisCode, diagnosisType, confidenceLevel);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    }
    else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to perform a valid prediction update operation.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction update. Please try again later.'
    });
  }
};

module.exports = {
  createPrediction,
  updatePredictionUser,
  updatePredictionWorker
};