const Appointment = require("../models/appointmentModel");

const getAppointmentById = async (appointmentId, userId) => {
  try {
    const appointment = await Appointment.findOne(
      { _id: appointmentId, userId }
    ).exec();

    if (!appointment) {
      return {
        type: "error",
        status: 404,
        error: "Appointment not found.",
      };
    }

    const responseData = {
      id: appointment._id.toString(),
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    };

    return {
      type: "success",
      status: 200,
      data: responseData
    };
  } catch (error) {
    console.error("Error retrieving appointment:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve appointment.",
    };
  }
};

const getAllAppointmentsByUserId = async (userId) => {
  try {
    const appointments = await Appointment.find({ userId }).sort({ dateTime: 1 }).exec();

    const formattedAppointments = appointments.map((appointment) => ({
      id: appointment._id.toString(),
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    }));

    return {
      type: "success",
      status: 200,
      data: formattedAppointments,
    };
  } catch (error) {
    console.error("Error retrieving all appointments:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to retrieve all appointments.",
    };
  }
};

const createAppointment = async (userId, payload) => {
  try {
    const newAppointment = new Appointment({ userId, ...payload });
    await newAppointment.save();

    const responseData = {
      id: newAppointment._id.toString(),
      title: newAppointment.title,
      description: newAppointment.description,
      appointmentDate: newAppointment.appointmentDate,
      institutionName: newAppointment.institutionName,
      address: newAppointment.address,
    };

    return {
      type: "success",
      status: 201,
      data: responseData,
    };
  } catch (error) {
    console.error("Error creating appointment:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to create a new appointment.",
    };
  }
};

const updateAppointment = async (appointmentId, userId, updatePayload) => {
  try {
    const appointment = await Appointment.findOne({ _id: appointmentId, userId }).exec();

    if (!appointment) {
      return {
        type: "error",
        status: 404,
        error: "Appointment not found.",
      };
    }

    Object.keys(updatePayload).forEach((key) => {
        appointment[key] = updatePayload[key];
      
    });

    await appointment.save();

    const updatedAppointmentData = {
      id: appointment._id.toString(),
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    };

    return {
      type: "success",
      status: 200,
      data: updatedAppointmentData,
    };
  } catch (error) {
    console.error("Error updating appointment:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to update the appointment.",
    };
  }
};

const deleteAppointment = async (appointmentId, userId) => {
  try {
    const result = await Appointment.deleteOne({
      _id: appointmentId,
      userId,
    }).exec();

    if (result.deletedCount === 0) {
      return {
        type: "error",
        status: 404,
        error: "Appointment not found for deletion.",
      };
    }

    return {
      type: "success",
      status: 204,
    };
  } catch (error) {
    console.error("Error deleting appointment:", error);
    return {
      type: "error",
      status: 500,
      error: "Failed to delete the appointment.",
    };
  }
};

module.exports = {
  getAppointmentById,
  getAllAppointmentsByUserId,
  createAppointment,
  updateAppointment,
  deleteAppointment,
};
