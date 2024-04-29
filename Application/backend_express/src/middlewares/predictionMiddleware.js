const multer = require('multer');
const ApiResponse = require("../responses/apiResponse");

const handleMulterUpload = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_UNEXPECTED_FILE') {
      return ApiResponse.error(res, {
        statusCode: 400,
        error: 'Only one image is allowed.'
      });
    }
    if (error.code === 'LIMIT_FILE_SIZE') {
      return ApiResponse.error(res, {
        statusCode: 400,
        error: 'The image size must be less than 10MB.'
      });
    }

    return ApiResponse.error(res, {
      statusCode: 400,
      error: 'An unexpected error occurred during image upload. Please try again later.'
    });

  } else if (error) {
    return ApiResponse.error(res, {
      statusCode: 400,
      error: 'An unexpected error occurred during image upload. Please try again later.'
    });
  }
  next();
};

module.exports = { handleMulterUpload };