const Prediction = require('../models/predictionModel');
const blobUtils = require('../services/azureStorageService');

const createPrediction = async (userId, title, description, imageBuffer) => {
    try {
        // Generate a unique blob name using a timestamp to prevent naming conflicts
        const blobName = `prediction-${Date.now()}.jpg`;

        // Upload the image to Azure Blob Storage and receive the URL back
        const imageUrl = await blobUtils.uploadImageToBlob(imageBuffer, blobName);

        // Create a new prediction record in MongoDB with the received image URL
        const prediction = new Prediction({
            userId,
            title,
            description,
            imageUrl,
            diagnosisName: null,  // Placeholder for future updates
            diagnosisCode: null,  // Placeholder for future updates
            status: 'pending'     // Initial status
        });
        await prediction.save();

        // Prepare a message for Azure Queue Storage
        const queueMessage = {
            predictionId: prediction._id.toString(),
            imageUrl,
            userId: userId.toString()
        };

        // Send the message to the queue for further processing
        await blobUtils.addToQueue(queueMessage);

        return prediction;
    } catch (error) {
        console.error('Error in createPrediction service:', error);
        throw error; // Ensure this error can be handled or logged by the caller
    }
};

module.exports = {
    createPrediction
};
