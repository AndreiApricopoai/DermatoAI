const multer = require("multer");
const ApiResponse = require("../responses/apiResponse");
const {
  ImageUploadMessages,
  StatusCode,
} = require("../responses/apiConstants");

const handleMulterUpload = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === "LIMIT_UNEXPECTED_FILE") {
      return ApiResponse.error(res, {
        statusCode: StatusCode.BAD_REQUEST,
        error: ImageUploadMessages.LimitUnexpectedFile,
      });
    }
    if (error.code === "LIMIT_FILE_SIZE") {
      return ApiResponse.error(res, {
        statusCode: StatusCode.BAD_REQUEST,
        error: ImageUploadMessages.LimitFileSize,
      });
    }

    return ApiResponse.error(res, {
      statusCode: StatusCode.BAD_REQUEST,
      error: ImageUploadMessages.UnexpectedError,
    });
  } else if (error) {
    return ApiResponse.error(res, {
      statusCode: StatusCode.BAD_REQUEST,
      error: ImageUploadMessages.UnexpectedError,
    });
  }
  next();
};

module.exports = { handleMulterUpload };