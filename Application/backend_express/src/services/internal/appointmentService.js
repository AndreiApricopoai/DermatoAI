const Appointment = require("../../models/appointmentModel");
const User = require("../../models/userModel");
const {
  ErrorMessages,
  StatusCodes,
  ResponseTypes,
  UserMessages,
} = require("../../responses/apiConstants");

const getAppointmentById = async (appointmentId, userId) => {
  try {
    const appointment = await Appointment.findOne({
      _id: appointmentId,
      userId,
    }).exec();

    if (!appointment) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    const responseData = {
      id: appointment._id,
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: responseData,
    };
  } catch (error) {
    console.error("Error retrieving appointment:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const getAllAppointmentsByUserId = async (userId) => {
  try {
    const appointments = await Appointment.find({ userId })
      .sort({ dateTime: 1 })
      .exec();

    const formattedAppointments = appointments.map((appointment) => ({
      id: appointment._id,
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    }));

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: formattedAppointments,
    };
  } catch (error) {
    console.error("Error retrieving all appointments:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const createAppointment = async (userId, payload) => {
  try {
    const existsUser = await User.findOne({ _id: userId }).exec();
    if (!existsUser) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: UserMessages.NotFound,
      };
    }

    const newAppointment = new Appointment({ userId, ...payload });
    await newAppointment.save();

    const responseData = {
      id: newAppointment._id,
      title: newAppointment.title,
      description: newAppointment.description,
      appointmentDate: newAppointment.appointmentDate,
      institutionName: newAppointment.institutionName,
      address: newAppointment.address,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Created,
      data: responseData,
    };
  } catch (error) {
    console.error("Error creating appointment:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
    };
  }
};

const updateAppointment = async (appointmentId, userId, updatePayload) => {
  try {
    const appointment = await Appointment.findOne({
      _id: appointmentId,
      userId,
    }).exec();

    if (!appointment) {
      return {
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    Object.keys(updatePayload).forEach((key) => {
      appointment[key] = updatePayload[key];
    });
    await appointment.save();

    const updatedAppointmentData = {
      id: appointment._id,
      title: appointment.title,
      description: appointment.description,
      appointmentDate: appointment.appointmentDate,
      institutionName: appointment.institutionName,
      address: appointment.address,
    };

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
      data: updatedAppointmentData,
    };
  } catch (error) {
    console.error("Error updating appointment:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
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
        type: ResponseTypes.Error,
        status: StatusCodes.NotFound,
        error: ErrorMessages.NotFound,
      };
    }

    return {
      type: ResponseTypes.Success,
      status: StatusCodes.Ok,
    };
  } catch (error) {
    console.error("Error deleting appointment:", error);
    return {
      type: ResponseTypes.Error,
      status: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedError,
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
