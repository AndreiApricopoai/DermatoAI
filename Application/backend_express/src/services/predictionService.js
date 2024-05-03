const Prediction = require('../models/predictionModel');
const azure = require('../services/azureStorageService');
const { createJwtToken, getTokenHash } = require('../utils/authUtils');
const crypto = require('crypto');
require('dotenv').config();

const createPrediction = async (userId, imageBuffer) => {

  let imageUrl;
  let prediction;

  try {
    const imageName = `prediction-${Date.now()}.jpg`;
    imageUrl = await azure.uploadImageToBlob(imageBuffer, imageName);

    const tokenPayload = {userId};
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

module.exports = {
  createPrediction
};