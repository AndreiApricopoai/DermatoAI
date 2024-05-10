const express = require('express');
const { checkAccessToken } = require('../middlewares/authMiddleware');
const { createAppointmentValidator, updateAppointmentValidator } = require('../request-validators/appointmentValidator');
const { validateObjectId } = require('../middlewares/mongooseMiddleware');
const appointmentController = require('../controllers/appointmentController');

// Create a new router for the appointment routes
const router = express.Router();

// Apply checkAccessToken middleware to all routes in this router
router.use(checkAccessToken);

// Appointment routes
router.get('/:id', validateObjectId, appointmentController.getAppointment);
router.get('/', appointmentController.getAllAppointments);
router.post('/', createAppointmentValidator, appointmentController.createAppointment);
router.patch('/:id', validateObjectId, updateAppointmentValidator, appointmentController.updateAppointment);
router.delete('/:id', validateObjectId, appointmentController.deleteAppointment);

module.exports = router;
