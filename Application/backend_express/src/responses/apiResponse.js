const { ErrorMessages, StatusCodes } = require("./apiConstants");

class ApiResponse {
  static success(res, { statusCode = StatusCodes.Ok, data = {} } = {}) {
    res.status(statusCode).json({
      isSuccess: true,
      apiResponseCode: 1,
      data: data,
    });
  }

  static error(
    res,
    { statusCode = StatusCodes.InternalServerError, error } = {}
  ) {
    res.status(statusCode).json({
      isSuccess: false,
      message: "Server error",
      apiResponseCode: 2,
      error: error,
    });
  }

  static validationError(
    res,
    { statusCode = StatusCodes.BadRequest, errors } = {}
  ) {
    res.status(statusCode).json({
      isSuccess: false,
      message: "Validation errors",
      apiResponseCode: 3,
      errors: errors,
    });
  }

  static handleResponse(res, response) {
    switch (response.type) {
      case "success":
        this.success(res, { statusCode: response.status, data: response.data });
        break;
      case "error":
        this.error(res, { statusCode: response.status, error: response.error });
        break;
      case "validationError":
        this.validationError(res, {
          statusCode: response.status,
          errors: response.errors,
        });
        break;
      default:
        this.error(res, {
          statusCode: StatusCodes.InternalServerError,
          error: { message: ErrorMessages.ResponseNotHandled },
        });
    }
  }
}

module.exports = ApiResponse;
