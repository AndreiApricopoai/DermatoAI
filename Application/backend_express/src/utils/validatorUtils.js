const ApiResponse = require('../responses/apiResponse');

const handleValidationError = (error, res) => {
  if (error) {
    ApiResponse.validationError(res, {
      statusCode: 400,
      errors: error.details.map(detail => ({
        message: detail.message,
        path: detail.path.join('.')
      }))
    });
    return true;
  }
  return false;
};

module.exports = { handleValidationError };
