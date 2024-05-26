const express = require("express");
const path = require("path");
const router = express.Router();

router.get("/terms", (req, res) => {
  res.sendFile(path.join(__dirname, "../public", "terms.html"));
});

router.get("/policy", (req, res) => {
  res.sendFile(path.join(__dirname, "../public", "policy.html"));
});

module.exports = router;
