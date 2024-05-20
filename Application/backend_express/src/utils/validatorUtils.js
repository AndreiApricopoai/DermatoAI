const ApiResponse = require("../responses/apiResponse");
const { StatusCodes } = require("../responses/apiConstants");

const handleValidationError = (error, res) => {
  if (error) {
    ApiResponse.validationError(res, {
      statusCode: StatusCodes.BadRequest,
      errors: error.details.map((detail) => ({
        message: detail.message,
        path: detail.path.join("."),
      })),
    });
    return true;
  }
  return false;
};

module.exports = { handleValidationError };
