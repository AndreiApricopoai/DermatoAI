const ApiResponse = require("../responses/apiResponse");
const sharp = require("sharp");
const {
  ImageUploadMessages,
  StatusCodes,
} = require("../responses/apiConstants");

const validateImage = async (req, res, next) => {
  try {
    if (!req.file || !req.file.buffer) {
      return ApiResponse.error(res, {
        statusCode: StatusCodes.BadRequest,
        error: ImageUploadMessages.NoImageUploaded,
      });
    }

    const image = sharp(req.file.buffer);
    const metadata = await image.metadata();

    if (
      metadata.width < 600 ||
      metadata.height < 450 ||
      Math.abs(metadata.width / metadata.height - 4 / 3) > 0.01
    ) {
      return ApiResponse.error(res, {
        statusCode: StatusCodes.BadRequest,
        error: ImageUploadMessages.InvalidImage,
      });
    }
    next();
  } catch (error) {
    console.error("Image validation error:", error);
    return ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ImageUploadMessages.ValidationFailed,
    });
  }
};

module.exports = validateImage;
