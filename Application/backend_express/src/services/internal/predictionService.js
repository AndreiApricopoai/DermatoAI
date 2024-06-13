require("dotenv").config();
const Prediction = require("../../models/predictionModel");
const User = require("../../models/userModel");
const azure = require("../external/azureStorageService");
const { createJwtToken, getTokenHash } = require("../../utils/authUtils");
const { getAzureBlobSasUrl } = require("../../utils/constants");
const {
  ErrorMessages,
  StatusCodes,
  ResponseTypes,
  UserMessages,
  TokenMessages,
  PredictionMessages,
} = require("../../responses/apiConstants");

const getPredictionById = async (predictionId, userId) => {
  console.log("se incearca o treaba !")
  try {
    const prediction = await Prediction.findOne({
      _id: predictionId,
      userId,
    }).exec();

    if (!prediction) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    const responseData = {
      id: prediction._id,
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: getAzureBlobSasUrl(prediction.imageUrl),
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
      createdAt: prediction.createdAt,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseData,
    };
  } catch (error) {
    console.error("Error retrieving prediction:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const getAllPredictionsByUserId = async (userId) => {
  try {
    const predictions = await Prediction.find({ userId })
      .sort({ dateTime: -1 })
      .exec();

    const formattedPredictions = predictions.map((prediction) => ({
      id: prediction._id,
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: getAzureBlobSasUrl(prediction.imageUrl),
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
      createdAt: prediction.createdAt
    }));

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: formattedPredictions,
    };
  } catch (error) {
    console.error("Error retrieving all predictions", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const createPrediction = async (userId, imageBuffer) => {
  let imageUrl;
  let prediction;

  try {
    const existsUser = await User.findOne({ _id: userId }).exec();
    if (!existsUser) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound,
      };
    }

    const imageName = `prediction-${Date.now()}.jpg`;
    imageUrl = await azure.uploadImageToBlob(imageBuffer, imageName);

    const tokenPayload = { userId };
    const workerToken = createJwtToken(
      process.env.WORKER_TOKEN_SECRET,
      "7d",
      tokenPayload
    );
    const workerTokenHash = getTokenHash(workerToken);

    if (!workerToken || !workerTokenHash) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: TokenMessages.TokenCreationError,
      };
    }

    prediction = new Prediction({
      userId,
      workerTokenHash,
      imageUrl,
    });
    await prediction.save();

    const queueMessage = {
      predictionId: prediction._id.toString(),
      userId: userId.toString(),
      workerToken,
      imageUrl,
    };
    await azure.addToQueue(queueMessage);

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Created,
      data: {
        message: PredictionMessages.Created,
        prediction: {
          predictionId: prediction._id,
          userId: prediction.userId,
          title: prediction.title,
          status: prediction.status,
          imageUrl: getAzureBlobSasUrl(prediction.imageUrl),
          createdAt: prediction.createdAt,
        },
      },
    };
  } catch (error) {
    console.error("Error in createPrediction service:", error);
    try {
      if (imageUrl) {
        const blobName = imageUrl.split("/").pop();
        await azure.deleteImageFromBlob(blobName);
      }
      if (prediction && prediction._id) {
        await Prediction.findByIdAndDelete(prediction._id);
      }
      console.error("Rollback successful after initial failure.");
    } catch (rollbackError) {
      console.error("Error during rollback:", rollbackError);
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.InternalServerError,
        error: PredictionMessages.RollbackFailed,
      };
    }
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: PredictionMessages.RollbackSucceeded,
    };
  }
};

const updatePredictionUser = async (predictionId, userId, updatePayload) => {
  try {
    const prediction = await Prediction.findOne({
      _id: predictionId,
      userId,
    }).exec();

    if (!prediction) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    Object.keys(updatePayload).forEach((key) => {
      prediction[key] = updatePayload[key];
    });
    await prediction.save();

    const updatedPredictionData = {
      id: prediction._id,
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: getAzureBlobSasUrl(prediction.imageUrl),
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
      createdAt: prediction.createdAt
    };
    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: updatedPredictionData,
    };
  } catch (error) {
    console.error("Error updating prediction:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const updatePredictionWorker = async (
  predictionId,
  userId,
  workerUpdatePayload
) => {
  try {
    const prediction = await Prediction.findOne({
      _id: predictionId,
      userId,
    }).exec();

    if (!prediction) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }
    const workerTokenHash = getTokenHash(workerUpdatePayload.workerToken);
    if (
      workerTokenHash === null ||
      workerTokenHash !== prediction.workerTokenHash
    ) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.Unauthorized,
        error: TokenMessages.UnauthorizedToken,
      };
    }
    workerUpdatePayload.workerToken = workerTokenHash;

    Object.keys(workerUpdatePayload).forEach((key) => {
      prediction[key] = workerUpdatePayload[key];
    });
    await prediction.save();

    const updatedWorkerPredictiontData = {
      id: prediction._id,
      userId: prediction.userId,
      title: prediction.title,
      description: prediction.description,
      imageUrl: getAzureBlobSasUrl(prediction.imageUrl),
      isHealthy: prediction.isHealthy,
      diagnosisName: prediction.diagnosisName,
      diagnosisCode: prediction.diagnosisCode,
      diagnosisType: prediction.diagnosisType,
      confidenceLevel: prediction.confidenceLevel,
      status: prediction.status,
      createdAt: prediction.createdAt
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: updatedWorkerPredictiontData,
    };
  } catch (error) {
    console.error("Error updating worker prediction:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const deletePrediction = async (predictionId, userId) => {
  let prediction;

  try {
    prediction = await Prediction.findOne({ _id: predictionId, userId }).exec();
    if (!prediction) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }
    await Prediction.deleteOne({ _id: predictionId });

    const blobName = prediction.imageUrl.split("/").pop();
    await azure.deleteImageFromBlob(blobName);

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
    };
  } catch (error) {
    console.error("Error deleting prediction: ", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

module.exports = {
  createPrediction,
  getPredictionById,
  getAllPredictionsByUserId,
  updatePredictionUser,
  updatePredictionWorker,
  deletePrediction,
};
