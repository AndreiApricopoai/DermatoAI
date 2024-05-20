const mongoose = require("mongoose");

const refreshTokenSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
    },
    tokenHash: {
      type: String,
      required: [true, "Token hash is required"],
    },
    expires: {
      type: Date,
      required: [true, "Token expiration date is required"],
    },
  },
  {
    collection: "refreshTokens",
    timestamps: true,
  }
);

const RefreshToken = mongoose.model("RefreshToken", refreshTokenSchema);

module.exports = RefreshToken;
