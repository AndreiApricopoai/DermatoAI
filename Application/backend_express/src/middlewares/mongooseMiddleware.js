const mongoose = require('mongoose');

const validateObjectId = (req, res, next) => {
  for (const key in req.params) {
    if (req.params.hasOwnProperty(key)) {
      const value = req.params[key];
      if (!mongoose.Types.ObjectId.isValid(value)) {
        return ApiResponse.error(res, {
          statusCode: 400,
          error: 'Invalid Object ID'
        });
      }
    }
  }
  next(); 
};

module.exports = { validateObjectId };
