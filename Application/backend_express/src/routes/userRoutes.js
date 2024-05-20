const express = require("express");
const { checkAccessToken } = require("../middlewares/authMiddleware");
const userController = require("../controllers/userController");

const router = express.Router();
router.use(checkAccessToken);

router.get("/me", userController.getProfile);
router.get("/me/verified", userController.getVerifiedStatus);

module.exports = router;
