const ApiResponse = require("../responses/apiResponse");
const appointmentService = require("../services/internal/appointmentService");
const { ErrorMessages, StatusCodes } = require("../responses/apiConstants");

const getAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await appointmentService.getAppointmentById(
      appointmentId,
      userId
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGet,
    });
  }
};

const getAllAppointments = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await appointmentService.getAllAppointmentsByUserId(userId);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorGetAll,
    });
  }
};

const createAppointment = async (req, res) => {
  try {
    const userId = req.currentUser.userId;
    const { title, description, appointmentDate, institutionName, address } =
      req.body;
    const payload = {
      title,
      description,
      appointmentDate,
      institutionName,
      address,
    };

    const result = await appointmentService.createAppointment(userId, payload);
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorCreate,
    });
  }
};

const updateAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await appointmentService.updateAppointment(
      appointmentId,
      userId,
      updatePayload
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorUpdate,
    });
  }
};

const deleteAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await appointmentService.deleteAppointment(
      appointmentId,
      userId
    );
    ApiResponse.handleResponse(res, result);
  } catch (error) {
    console.log(error);
    ApiResponse.error(res, {
      statusCode: StatusCodes.InternalServerError,
      error: ErrorMessages.UnexpectedErrorDelete,
    });
  }
};

module.exports = {
  getAppointment,
  getAllAppointments,
  createAppointment,
  updateAppointment,
  deleteAppointment,
};
