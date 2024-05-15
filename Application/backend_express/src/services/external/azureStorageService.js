require('dotenv').config();
const { BlobServiceClient } = require('@azure/storage-blob');
const { QueueServiceClient } = require('@azure/storage-queue');
const { v4: uuidv4 } = require('uuid');
const { getAzureBlobUrl } = require('../utils/constants');

const blobServiceClient = BlobServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const containerClient = blobServiceClient.getContainerClient(process.env.BLOB_CONTAINER_NAME);

const queueServiceClient = QueueServiceClient.fromConnectionString(process.env.STORAGE_CONNECTION_STRING);
const queueClient = queueServiceClient.getQueueClient(process.env.QUEUE_CONTAINER_NAME);

const uploadImageToBlob = async (imageBuffer, imageName) => {
  const blobName = `${uuidv4()}${imageName}`;
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  const options = { blobHTTPHeaders: { blobContentType: 'image/jpeg' } };

  await blockBlobClient.uploadData(imageBuffer, options);
  return getAzureBlobUrl(blobName);
};

const deleteImageFromBlob = async (blobName) => {
  const blockBlobClient = containerClient.getBlockBlobClient(blobName);
  await blockBlobClient.delete();
};

const addToQueue = async (message) => {
  const encodedMessage = Buffer.from(JSON.stringify(message)).toString('base64');
  const response = await queueClient.sendMessage(encodedMessage);

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