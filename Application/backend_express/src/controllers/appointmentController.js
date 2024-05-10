const ApiResponse = require('../responses/apiResponse');
const appointmentService = require('../services/appointmentService');

// Get a single appointment by appointment ID for the current user
const getAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await appointmentService.getAppointmentById(appointmentId, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve the appointment.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during the appointment retrieval. Please try again later.'
    });
  }
};

// Get all appointments for the current user
const getAllAppointments = async (req, res) => {
  try {
    const userId = req.currentUser.userId;

    const result = await appointmentService.getAllAppointmentsByUserId(userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to retrieve all appointments.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during appointments retrieval. Please try again later.'
    });
  }
};

// Create a new appointment for the current user
const createAppointment = async (req, res) => {
  try {
    const { title, description, appointmentDate, institutionName, address } = req.body;
    const payload = { title, description, appointmentDate, institutionName, address };
    const userId = req.currentUser.userId;

    const result = await appointmentService.createAppointment(userId, payload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to create a new appointment.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during appointment creation. Please try again later.'
    });
  }
};

// Update an existing appointment for the current user
const updateAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;
    const updatePayload = req.body;

    const result = await appointmentService.updateAppointment(appointmentId, userId, updatePayload);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to update the appointment.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during appointment update. Please try again later.'
    });
  }
};

// Delete an appointment by appointment ID for the current user
const deleteAppointment = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const userId = req.currentUser.userId;

    const result = await appointmentService.deleteAppointment(appointmentId, userId);

    if (result && result.type) {
      return ApiResponse.handleResponse(res, result);
    } else {
      return ApiResponse.error(res, {
        statusCode: 500,
        error: 'The service failed to delete the appointment.'
      });
    }
  } catch (error) {
    console.log(error);
    return ApiResponse.error(res, {
      statusCode: 500,
      error: 'An unexpected error occurred during appointment deletion. Please try again later.'
    });
  }
};

module.exports = {
  getAppointment,
  getAllAppointments,
  createAppointment,
  updateAppointment,
  deleteAppointment
};
