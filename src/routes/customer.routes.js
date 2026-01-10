const express = require("express");
const { apiKeyAuth } = require("../middleware/apiKeyAuth");
const { viewAllCustomers } = require("../controllers/customer.controller");

const router = express.Router();

router.get("/viewall", apiKeyAuth, viewAllCustomers);

module.exports = router;
