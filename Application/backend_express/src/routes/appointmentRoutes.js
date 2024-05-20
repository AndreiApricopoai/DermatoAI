const express = require("express");
const { checkAccessToken } = require("../middlewares/authMiddleware");
const {
  createAppointmentValidator,
  updateAppointmentValidator,
} = require("../request-validators/appointmentValidator");
const { validateParamId } = require("../middlewares/mongooseMiddleware");
const appointmentController = require("../controllers/appointmentController");

const router = express.Router();
router.use(checkAccessToken);

router.get("/:id", validateParamId, appointmentController.getAppointment);
router.get("/", appointmentController.getAllAppointments);
router.post(
  "/",
  createAppointmentValidator,
  appointmentController.createAppointment
);
router.patch(
  "/:id",
  validateParamId,
  updateAppointmentValidator,
  appointmentController.updateAppointment
);
router.delete("/:id", validateParamId, appointmentController.deleteAppointment);

module.exports = router;
