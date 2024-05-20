const multer = require("multer");
const ApiResponse = require("../responses/apiResponse");
const {
  ImageUploadMessages,
  StatusCodes,
} = require("../responses/apiConstants");

const handleMulterUpload = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === "LIMIT_UNEXPECTED_FILE") {
      return ApiResponse.error(res, {
        statusCode: StatusCodes.BadRequest,
        error: ImageUploadMessages.LimitUnexpectedFile,
      });
    }
    if (error.code === "LIMIT_FILE_SIZE") {
      return ApiResponse.error(res, {
        statusCode: StatusCodes.BadRequest,
        error: ImageUploadMessages.LimitFileSize,
      });
    }

    return ApiResponse.error(res, {
      statusCode: StatusCodes.BadRequest,
      error: ImageUploadMessages.UnexpectedError,
    });
  } else if (error) {
    return ApiResponse.error(res, {
      statusCode: StatusCodes.BadRequest,
      error: ImageUploadMessages.UnexpectedError,
    });
  }
  next();
};

module.exports = { handleMulterUpload };
