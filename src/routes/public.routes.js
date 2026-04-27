const express = require("express");

const router = express.Router();

router.get("/hello", (req, res) => {
  console.log("Hello endpoint called");
  console.log(req.body);
  res.json({ message: req.body || "Hello, world!" });
});

router.post("/hello", (req, res) => {
  console.log("Hello endpoint called");
  console.log(req.body);
  res.json({ message: req.body || "Hello, world!" });
});

module.exports = router;
