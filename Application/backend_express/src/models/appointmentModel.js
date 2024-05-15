const mongoose = require("mongoose");

const appointmentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User ID is required"],
    },
    title: {
      type: String,
      required: [true, "Title of the appointment is required"],
      trim: true,
      minLength: [1, "Title must be at least 1 character long"],
      maxlength: [100, "Title cannot be more than 100 characters"],
    },
    description: {
      type: String,
      trim: true,
      maxlength: [500, "Description cannot be more than 500 characters"],
    },
    appointmentDate: {
      type: Date,
      required: [true, "Date and time of the appointment are required"],
    },
    institutionName: {
      type: String,
      trim: true,
      maxlength: [100, "Institution name cannot be more than 100 characters"],
    },
    address: {
      type: String,
      trim: true,
      maxlength: [200, "Address cannot be more than 200 characters"],
    },
  },
  {
    collection: "appointments",
    timestamps: true,
  }
);

const Appointment = mongoose.model("Appointment", appointmentSchema);

module.exports = Appointment;
