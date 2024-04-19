exports.success = (res, data, message = 'Success') => {
    res.status(200).json({
      message: message,
      data: data,
    });
  };
  
  exports.error = (res, message = 'Error', statusCode = 500) => {
    res.status(statusCode).json({
      message: message,
    });
  };
  
  exports.validationError = (res, errors) => {
    res.status(400).json({
      message: 'Validation errors',
      errors: errors,
    });
  };