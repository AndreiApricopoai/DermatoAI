require('dotenv').config();
const Prediction = require('../../models/predictionModel');
const azure = require('../external/azureStorageService');
const { createJwtToken, getTokenHash } = require('../../utils/authUtils');

const getPredictionById = async (userId, predictionId) => {
  try {
    const prediction = await Prediction.findOne(
      { _id: predictionId, userId }
    ).exec();

    if (!prediction) {
      return {
        type: "error",
        status: 404,
        error: "Prediction not found.",
      };
    }

    const responseData = {
      id: prediction._id.toString(),
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: prediction.imageUrl,
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
    };

    return {
      type: "success",
      status: 200,
      data: responseData
    };
  } catch (error) {
    console.error("Error retrieving prediction:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve prediction.",
    };
  }
};

const getAllPredictionsByUserId = async (userId) => {
  try {
    const predictions = await Prediction.find({ userId }).sort({ dateTime: 1 }).exec();

    const formattedPredictions = predictions.map((prediction) => ({
      id: prediction._id.toString(),
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: prediction.imageUrl,
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
    }));

    return {
      type: "success",
      status: 200,
      data: formattedPredictions,
    };
  } catch (error) {
    console.error("Error retrieving all predictions", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve all predictions.",
    };
  }
};

const createPrediction = async (userId, imageBuffer) => {

  let imageUrl;
  let prediction;

  try {
    const imageName = `prediction-${Date.now()}.jpg`;
    imageUrl = await azure.uploadImageToBlob(imageBuffer, imageName);

    const tokenPayload = { userId };
    const workerToken = createJwtToken(process.env.WORKER_TOKEN_SECRET, '7d', tokenPayload);
    const workerTokenHash = getTokenHash(workerToken);

    if (!workerToken || !workerTokenHash) {
      return {
        type: 'error',
        status: 500,
        error: 'An error occurred while creating the worker token.'
      };
    }

    prediction = new Prediction({
      userId,
      workerTokenHash,
      imageUrl
    });
    await prediction.save();

    const queueMessage = {
      predictionId: prediction._id.toString(),
      userId: userId.toString(),
      workerToken,
      imageUrl
    };
    await azure.addToQueue(queueMessage);

    return {
      type: 'success',
      status: 201,
      data: {
        message: 'Prediction created successfully and added to queue for processing.',
        prediction: {
          predictionId: prediction._id,
          userId,
          title,
          status,
          imageUrl
        }
      }
    };
  }
  catch (error) {
    console.error('Error in createPrediction service:', error);

    try {
      if (imageUrl) {
        const blobName = imageUrl.split('/').pop();
        await azure.deleteImageFromBlob(blobName);
      }
      if (prediction && prediction._id) {
        await Prediction.findByIdAndDelete(prediction._id);
      }
      console.error('Rollback successful after initial failure.');

    } catch (rollbackError) {
      console.error('Error during rollback:', rollbackError);
      return {
        type: 'error',
        status: 500,
        error: 'An unexpected error occurred during prediction creation and operation rollback failed. Please try again later.'
      };
    }
    return {
      type: 'error',
      status: 500,
      error: 'An unexpected error occurred during prediction creation and operation rollback succeeded. Please try again later.'
    };
  }
};

const updatePredictionUser = async (predictionId, userId, updatePayload) => {
  try {
    const prediction = await Prediction.findOne({ _id: predictionId, userId }).exec();

    if (!prediction) {
      return {
        type: "error",
        status: 404,
        error: "Prediction not found.",
      };
    }

    Object.keys(updatePayload).forEach((key) => {
      prediction[key] = updatePayload[key];
    });

    await prediction.save();

    const updatedPredictionData = {
      id: prediction._id.toString(),
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: prediction.imageUrl,
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
    };

    return {
      type: "success",
      status: 200,
      data: updatedPredictionData,
    };
  } catch (error) {
    console.error("Error updating prediction:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to update the prediction.",
    };
  }
};

const updatePredictionWorker = async (predictionId, userId, workerUpdatePayload) => {
  try {
    const prediction = await Prediction.findOne({ _id: predictionId, userId }).exec();

    if (!prediction) {
      return {
        type: "error",
        status: 404,
        error: "Prediction not found.",
      };
    }

    const workerTokenHash = getTokenHash(workerUpdatePayload.workerToken);
    if (workerTokenHash === null || workerTokenHash !== prediction.workerTokenHash) {
      return {
        type: "error",
        status: 401,
        error: "Unauthorized worker token.",
      };
    }

    workerUpdatePayload.workerToken = workerTokenHash;

    Object.keys(workerUpdatePayload).forEach((key) => {
      prediction[key] = workerUpdatePayload[key];
    });

    await prediction.save();

    const updatedWorkerPredictiontData = {
      id: prediction._id.toString(),
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: prediction.imageUrl,
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status
    };

    return {
      type: "success",
      status: 200,
      data: updatedWorkerPredictiontData,
    };
  } catch (error) {
    console.error("Error updating worker prediction:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to update the worker prediction.",
    };
  }
};

const deletePrediction = async (predictionId, userId) => {
  let prediction;
  try {
    prediction = await Prediction.findOne({ _id: predictionId, userId }).exec();
    if (!prediction) {
      return {
        type: "error",
        status: 404,
        error: "Prediction not found for deletion.",
      };
    }

    const blobName = prediction.imageUrl.split('/').pop();
    await azure.deleteImageFromBlob(blobName);

    try {
      await prediction.remove();
      return {
        type: "success",
        status: 204,
      };
    } catch (error) {
      console.error("Error during prediction document deletion, attempting retry:", error);
      await prediction.remove(); 
      return {
        type: "success",
        status: 204,
      };
    }

  } catch (error) {
    console.error("Error deleting prediction or failure after retry:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to delete the prediction after retry. Manual intervention required.",
    };
  }
};

module.exports = {
  createPrediction,
  getPredictionById,
  getAllPredictionsByUserId,
  updatePredictionUser,
  updatePredictionWorker,
  deletePrediction
};