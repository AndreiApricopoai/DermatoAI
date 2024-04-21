class ApiResponse {
  static success(res, statusCode = 200, data = {}) {
      res.status(statusCode).json({
          isSuccess: true,
          data: data
      });
  }

  static error(res, statusCode = 500, message = 'Error') {
      res.status(statusCode).json({
          isSuccess: false,
          message: message
      });
  }

  static validationError(res, statusCode = 400, errors) {
      res.status(statusCode).json({
          isSuccess: false,
          message: 'Validation errors',
          errors: errors
      });
  }

  static handleResponse(res, response) {
      switch (response.type) {
          case 'success':
              this.success(res, response.status, response.data);
              break;
          case 'error':
              this.error(res, response.status, response.message);
              break;
          case 'validationError':
              this.validationError(res, response.status, response.errors);
              break;
          default:
              this.error(res, 500, {response: 'Response not handled by the server'} );
      }
  }
}

module.exports = ApiResponse;