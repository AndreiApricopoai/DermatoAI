const mongoose = require("mongoose");
const { MongooseMessages, StatusCode } = require("../responses/apiConstants");

const validateParamId = (req, res, next) => {
  for (const key in req.params) {
    if (req.params.hasOwnProperty(key)) {
      const value = req.params[key];
      if (!mongoose.Types.ObjectId.isValid(value)) {
        return ApiResponse.error(res, {
          statusCode: StatusCode.BAD_REQUEST,
          error: MongooseMessages.CastError,
        });
      }
    }
  }
  next();
};

module.exports = { validateParamId };