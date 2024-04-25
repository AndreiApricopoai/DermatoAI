const { BlobServiceClient } = require('@azure/storage-blob');
const { QueueServiceClient } = require('@azure/storage-queue');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config();

// Blob Service Setup
const blobServiceClient = BlobServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const containerClient = blobServiceClient.getContainerClient(process.env.BLOB_CONTAINER_NAME);

// Queue Service Setup
const queueServiceClient = QueueServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const queueClient = queueServiceClient.getQueueClient(process.env.QUEUE_CONTAINER_NAME);

const uploadImageToBlob = async (buffer, originalName) => {
    // Generate a unique blob name using UUID
    const blobName = `${uuidv4()}${originalName}`;
    const blockBlobClient = containerClient.getBlockBlobClient(blobName);
    try {
        // Upload the buffer directly
        await blockBlobClient.uploadData(buffer);
        const imageUrl = `https://${process.env.STORAGE_CONNECTION_STRING}.blob.core.windows.net/container-name/${blobName}`;
        return imageUrl;
    } catch (error) {
        console.error('Upload to blob storage failed:', error);
        throw error;
    }
};

const addToQueue = async (message) => {
    try {
        // Encode message as a base64 string
        const encodedMessage = Buffer.from(JSON.stringify(message)).toString('base64');
        const response = await queueClient.sendMessage(encodedMessage);
        return { messageId: response.messageId, insertionTime: response.insertedOn };
    } catch (error) {
        console.error('Error sending message to queue:', error);
        throw error;
    }
};

module.exports = {
    uploadImageToBlob,
    addToQueue
};
