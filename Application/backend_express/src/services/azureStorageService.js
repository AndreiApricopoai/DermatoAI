const { BlobServiceClient } = require('@azure/storage-blob');
const { QueueServiceClient } = require('@azure/storage-queue');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config();

// Blob client
const blobServiceClient = BlobServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const containerClient = blobServiceClient.getContainerClient(process.env.BLOB_CONTAINER_NAME);

// Queue client
const queueServiceClient = QueueServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const queueClient = queueServiceClient.getQueueClient(process.env.QUEUE_CONTAINER_NAME);

// Upload an image to Azure Blob Storage
const uploadImageToBlob = async (imageBuffer, imageName) => {
  const blobName = `${uuidv4()}${imageName}`;
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  const options = { blobHTTPHeaders: { blobContentType: 'image/jpeg' } };

  await blockBlobClient.uploadData(imageBuffer, options);
  
  const imageUrl = `https://${process.env.STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${process.env.BLOB_CONTAINER_NAME}/${blobName}`;
  console.log('Upload successful:', imageUrl);
  return imageUrl;
};

// Delete an image from Azure Blob Storage
const deleteImageFromBlob = async (blobName) => {
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);

  await blockBlobClient.delete();
  console.log(`Blob ${blobName} deleted successfully.`);
};

// Add a message to Azure Queue Storage
const addToQueue = async (message) => {
  const encodedMessage = Buffer.from(JSON.stringify(message)).toString('base64');
  const response = await queueClient.sendMessage(encodedMessage);

  console.log(`Message sent successfully with ID: ${response.messageId}`);
  console.log(`Message inserted at: ${response.insertedOn}`);

  return {
    messageId: response.messageId,
    insertionTime: response.insertedOn
  };
};

module.exports = {
  uploadImageToBlob,
  deleteImageFromBlob,
  addToQueue
};