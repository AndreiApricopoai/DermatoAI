const predictionService = require('../services/predictionService');
const ApiResponse = require('../responses/apiResponse');

const getPrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.getPredictionById(userId, predictionId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve the prediction.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during prediction retrieval. Please try again later.'
    });
  }
};

// Get all appointments for the current user
const getAllPredictions = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await predictionService.getAllPredictionsByUserId(userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve the predictions.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during predictions retrieval. Please try again later.'
    });
  }
};

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
    const updatePayload = req.body;

    const result = await predictionService.updatePredictionUser(predictionId, userId, updatePayload);

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
    const userId = req.currentUser.userId;
    const workerUpdatePayload = req.body;

    const result = await predictionService.updatePredictionWorker(predictionId, userId, workerUpdatePayload);

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


const deletePrediction = async (req, res) => {
  try {
    const predictionId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await predictionService.deletePrediction(predictionId, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to delete the prediction.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
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