const express = require("express");
const { checkAccessToken } = require("../middlewares/authMiddleware");
const {
  coordinatesValidator,
  photoReferenceValidator,
} = require("../request-validators/locationValidator");
const locationController = require("../controllers/locationController");

const router = express.Router();
router.use(checkAccessToken);

router.get("/", coordinatesValidator, locationController.getAllLocations);
router.get(
  "/fetch-image/:photoReference",
  photoReferenceValidator,
  locationController.getLocationImage
);

module.exports = router;