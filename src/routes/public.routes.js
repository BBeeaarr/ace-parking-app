const express = require("express");

const router = express.Router();

router.get("/hello", (req, res) => {
  res.json({ message: req.body.message || "Hello, world!" });
});

module.exports = router;
