const express = require("express");
const { apiKeyAuth } = require("../middleware/apiKeyAuth");
const {
  viewAllOrders,
  viewOrderDetailAll,
  getOrderDetailsByInvoiceNumber,
  createNewOrder,
} = require("../controllers/order.controller");

const router = express.Router();

router.get("/viewall", apiKeyAuth, viewAllOrders);
router.get("/vieworderdetail", apiKeyAuth, viewOrderDetailAll);
router.get("/details/:invoiceNumber", apiKeyAuth, getOrderDetailsByInvoiceNumber);
router.post("/new", apiKeyAuth, createNewOrder);

module.exports = router;
