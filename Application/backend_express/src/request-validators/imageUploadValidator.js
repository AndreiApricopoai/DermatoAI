const sharp = require('sharp');
const ApiResponse = require('../responses/apiResponse');

const validateImage = async (req, res, next) => {
  try {
    if (!req.file || !req.file.buffer) {
      return ApiResponse.error(res, {
        statusCode: 400,
        error: 'No image uploaded.'
      });
    }

    const image = sharp(req.file.buffer);
    const metadata = await image.metadata();

    if (metadata.width < 600 || metadata.height < 450 || Math.abs(metadata.width / metadata.height - 4 / 3) > 0.01) {
      return ApiResponse.error(res, {
        statusCode: 400,
        error: 'Image must be at least 600x450 pixels, approximately a 4:3 aspect ratio.'
      });
    }

    next();
  } catch (error) {
    console.error('Image validation error:', error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'Failed to validate the image. Please try again.'
    });
  }
};

module.exports = validateImage;