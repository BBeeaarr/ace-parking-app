const express = require("express");
const { apiKeyAuth } = require("../middleware/apiKeyAuth");
const { viewAllProducts } = require("../controllers/product.controller");

const router = express.Router();

router.get("/viewall", apiKeyAuth, viewAllProducts);

module.exports = router;
