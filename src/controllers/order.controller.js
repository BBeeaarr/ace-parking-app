const { getPool, sql } = require("../db/pool");
const crypto = require("crypto");
/**
 * GET /api/order/viewall
 * Summary list (one row per order)
 */
async function viewAllOrders(req, res, next) {
  try {
    const pool = await getPool();

    const result = await pool.request().query(`
      SELECT
        invoiceNumber = i.invoice_number,
        invoiceDate = i.invoice_date,
        customerId = c.customer_id,
        customerName = c.customer_name,
        lineItemCount = COUNT(ili.line_item_id),
        orderTotal = COALESCE(SUM(ili.quantity * p.product_cost), 0)
      FROM invoices i
      JOIN customers c ON c.customer_id = i.customer_id
      LEFT JOIN invoice_line_items ili ON ili.invoice_number = i.invoice_number
      LEFT JOIN products p ON p.product_id = ili.product_id
      GROUP BY i.invoice_number, i.invoice_date, c.customer_id, c.customer_name
      ORDER BY i.invoice_date DESC, i.invoice_number DESC
    `);

    res.json(result.recordset);
  } catch (err) {
    next(err);
  }
}

/**
 * Helper to group flat join rows -> nested order object
 */
function groupOrderRows(rows) {
  const ordersByInvoice = new Map();

  for (const r of rows) {
    const key = r.invoiceNumber;

    if (!ordersByInvoice.has(key)) {
      ordersByInvoice.set(key, {
        invoiceNumber: r.invoiceNumber,
        invoiceDate: r.invoiceDate,
        customerId: r.customerId,
        customerName: r.customerName,
        lineItems: [],
      });
    }

    // If there are no line items, the join columns may be null
    if (r.lineItemId) {
      ordersByInvoice.get(key).lineItems.push({
        lineItemId: r.lineItemId,
        productId: r.productId,
        productName: r.productName,
        quantity: r.quantity,
        unitPrice: r.unitPrice,
        lineTotal: r.lineTotal,
      });
    }
  }

  return Array.from(ordersByInvoice.values());
}

/**
 * GET /api/order/vieworderdetail
 * Returns all orders with full line item details (nested)
 */
async function viewOrderDetailAll(req, res, next) {
  try {
    const pool = await getPool();

    const result = await pool.request().query(`
      SELECT
        invoiceNumber = i.invoice_number,
        invoiceDate = i.invoice_date,
        customerId = i.customer_id,
        customerName = c.customer_name,

        lineItemId = ili.line_item_id,
        productId = ili.product_id,
        productName = p.product_name,
        quantity = ili.quantity,
        unitPrice = p.product_cost,
        lineTotal = (ili.quantity * p.product_cost)
      FROM invoices i
      JOIN customers c ON c.customer_id = i.customer_id
      LEFT JOIN invoice_line_items ili ON ili.invoice_number = i.invoice_number
      LEFT JOIN products p ON p.product_id = ili.product_id
      ORDER BY i.invoice_date DESC, i.invoice_number DESC, ili.line_item_id ASC
    `);

    res.json(groupOrderRows(result.recordset));
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/order/details/{invoiceNumber}
 * Returns a single order with full details (nested)
 */
async function getOrderDetailsByInvoiceNumber(req, res, next) {
  try {
    const invoiceNumber = Number(req.params.invoiceNumber);
    if (!Number.isInteger(invoiceNumber) || invoiceNumber <= 0) {
      return res.status(400).json({ message: "Error retrieving Order details" });
    }

    const pool = await getPool();
    const request = pool.request();
    request.input("invoiceNumber", sql.Int, invoiceNumber);

    // One query that returns one row per line item (or a single row with null line item columns if none)
    // IMPORTANT: alias columns to camelCase to satisfy the prompt.
    const result = await request.query(`
      SELECT
        -- customerDetail
        customerId = c.customer_id,
        customerName = c.customer_name,
        customerAddress1 = c.customer_address1,
        customerAddress2 = c.customer_address2,
        customerCity = c.customer_city,
        customerState = c.customer_state,
        customerPostalCode = c.customer_postal_code,
        customerTelephone = c.customer_telephone,
        customerContactName = c.customer_contact_name,
        customerEmailAddress = c.customer_email_address,

        -- orderDetail
        invoiceNumber = i.invoice_number,
        invoiceDate = i.invoice_date,
        orderCustomerId = i.customer_id,

        -- lineItems
        lineItemId = ili.line_item_id,
        productId = ili.product_id,
        quantity = ili.quantity,
        lineInvoiceDate = i.invoice_date,
        productName = p.product_name,
        productCost = CAST(p.product_cost AS DECIMAL(10, 2)),
        totalCost = CAST(ili.quantity * p.product_cost AS DECIMAL(10, 2))
      FROM invoices i
      JOIN customers c ON c.customer_id = i.customer_id
      LEFT JOIN invoice_line_items ili ON ili.invoice_number = i.invoice_number
      LEFT JOIN products p ON p.product_id = ili.product_id
      WHERE i.invoice_number = @invoiceNumber
      ORDER BY ili.line_item_id ASC
    `);

    const rows = result.recordset;

    if (!rows || rows.length === 0) {
      return res.status(400).json({ message: "Error retrieving Order details" });
    }

    // Base objects come from the first row (same for all rows)
    const first = rows[0];

    const response = {
      customerDetail: {
        customerId: first.customerId,
        customerName: first.customerName,
        customerAddress1: first.customerAddress1,
        customerAddress2: first.customerAddress2,
        customerCity: first.customerCity,
        customerState: first.customerState,
        customerPostalCode: first.customerPostalCode,
        customerTelephone: first.customerTelephone,
        customerContactName: first.customerContactName,
        customerEmailAddress: first.customerEmailAddress,
      },
      orderDetail: {
        invoiceNumber: first.invoiceNumber,
        invoiceDate: first.invoiceDate, // will serialize as ISO string
        customerId: first.orderCustomerId,
      },
      lineItems: [],
    };

    // Build lineItems array; handle orders with 0 line items (LEFT JOIN)
    for (const r of rows) {
      if (!r.lineItemId) continue;

      response.lineItems.push({
        lineItemId: r.lineItemId,
        productId: r.productId,
        quantity: r.quantity,
        invoiceDate: r.lineInvoiceDate,
        productName: r.productName,
        productCost: r.productCost,
        totalCost: r.totalCost,
      });
    }

    return res.json(response);
  } catch (err) {
    next(err);
  }
}


/**
 * POST /api/order/new
 * Body (example):
 * {
 *   "customerId": "aa5f...9d71",
 *   "invoiceDate": "2024-12-20T14:30:00",
 *   "lineItems": [
 *     {"productId":"...", "quantity":2},
 *     {"productId":"...", "quantity":1}
 *   ]
 * }
 */

async function createNewOrder(req, res, next) {
  const body = req.body || {};
  const invoiceData = body.invoiceData || {};
  const products = body.products;

  // ---- 400 validation ----
  if (!invoiceData || typeof invoiceData !== "object") {
    return res.status(400).json({ message: "invoiceData is required" });
  }
  if (!isUuid(invoiceData.customerId)) {
    return res.status(400).json({ message: "invoiceData.customerId must be a UUID" });
  }
  const invoiceDate = parseIsoDate(invoiceData.invoiceDate);
  if (!invoiceDate) {
    return res.status(400).json({ message: "invoiceData.invoiceDate must be a valid ISO date string" });
  }

  if (!Array.isArray(products) || products.length === 0) {
    return res.status(400).json({ message: "products must be a non-empty array" });
  }

  for (const p of products) {
    if (!p || typeof p !== "object") {
      return res.status(400).json({ message: "Each product must be an object" });
    }
    if (!isUuid(p.productId)) {
      return res.status(400).json({ message: "Each productId must be a UUID" });
    }
    if (!Number.isInteger(p.quantity) || p.quantity <= 0) {
      return res.status(400).json({ message: "Each quantity must be a positive integer" });
    }
  }

  // Optional: combine duplicates by productId (so inserts are clean)
  const qtyByProductId = new Map();
  for (const p of products) {
    qtyByProductId.set(p.productId, (qtyByProductId.get(p.productId) || 0) + p.quantity);
  }
  const distinctProducts = Array.from(qtyByProductId.entries()).map(([productId, quantity]) => ({
    productId,
    quantity,
  }));

  try {
    const pool = await getPool();
    const tx = new sql.Transaction(pool);

    await tx.begin(sql.ISOLATION_LEVEL.SERIALIZABLE); // simplest safe choice for "MAX+1"

    try {
      // ---- 1) Allocate next invoice_number safely ----
      // SERIALIZABLE prevents a race where two requests pick the same MAX+1.
      const nextInvoiceReq = new sql.Request(tx);
      const nextInvoiceResult = await nextInvoiceReq.query(`
        SELECT nextInvoiceNumber = ISNULL(MAX(invoice_number), 0) + 1
        FROM dbo.invoices;
      `);
      const invoiceNumber = nextInvoiceResult.recordset[0].nextInvoiceNumber;

      // ---- 2) Load product details (name + cost) ----
      // Assumption: dbo.products has product_id, product_name, product_cost.
      // If your schema differs, change the SELECT/aliases.
      const productIds = distinctProducts.map((p) => p.productId);

      const lookupReq = new sql.Request(tx);
      // Use a table-valued parameter alternative later; MVP uses IN (...) safely via parameters:
      // We'll build parameterized inputs to avoid injection.
      const inParams = productIds.map((id, i) => {
        const key = `pid${i}`;
        lookupReq.input(key, sql.UniqueIdentifier, id);
        return `@${key}`;
      }).join(", ");

      const productLookup = await lookupReq.query(`
        SELECT
          productId = p.product_id,
          productName = p.product_name,
          productCost = p.product_cost
        FROM dbo.products p
        WHERE p.product_id IN (${inParams});
      `);

      if (productLookup.recordset.length !== productIds.length) {
        // Find missing IDs for a clean 400
        const found = new Set(productLookup.recordset.map((r) => r.productId.toLowerCase()));
        const missing = productIds.filter((id) => !found.has(id.toLowerCase()));
        return res.status(400).json({
          message: "One or more productIds do not exist",
          missingProductIds: missing,
        });
      }

      const productById = new Map(
        productLookup.recordset.map((r) => [r.productId.toLowerCase(), r])
      );

      // ---- 3) Insert invoice ----
      const invReq = new sql.Request(tx);
      invReq.input("invoiceNumber", sql.Int, invoiceNumber);
      invReq.input("invoiceDate", sql.DateTime2(0), invoiceDate);
      invReq.input("customerId", sql.UniqueIdentifier, invoiceData.customerId);

      await invReq.query(`
        INSERT INTO dbo.invoices (invoice_number, invoice_date, customer_id)
        VALUES (@invoiceNumber, @invoiceDate, @customerId);
      `);

      // ---- 4) Insert line items ----
      for (const item of distinctProducts) {
        const product = productById.get(item.productId.toLowerCase());
        const productCost = Number(product.productCost);
        const totalCost = productCost * item.quantity;

        const liReq = new sql.Request(tx);
        liReq.input("lineItemId", sql.UniqueIdentifier, crypto.randomUUID()); // driver-generated GUID
        liReq.input("invoiceNumber", sql.Int, invoiceNumber);
        liReq.input("productId", sql.UniqueIdentifier, item.productId);
        liReq.input("quantity", sql.Int, item.quantity);
        liReq.input("productName", sql.NVarChar(200), product.productName);
        liReq.input("productCost", sql.Decimal(19, 4), productCost);
        liReq.input("totalCost", sql.Decimal(19, 4), totalCost);

        await liReq.query(`
          INSERT INTO dbo.invoice_line_items
            (line_item_id, invoice_number, product_id, quantity, product_name, product_cost, total_cost)
          VALUES
            (@lineItemId, @invoiceNumber, @productId, @quantity, @productName, @productCost, @totalCost);
        `);
      }

      await tx.commit();

      // ---- 5) Return the created invoice (reuse details function) ----
      req.params.invoiceNumber = String(invoiceNumber);
      return getOrderDetailsByInvoiceNumber(req, res, next);
    } catch (innerErr) {
      await tx.rollback();
      throw innerErr;
    }
  } catch (err) {
    // FK failures etc.
    if (err && typeof err.message === "string" && err.message.toLowerCase().includes("foreign key")) {
      return res.status(400).json({ message: "Invalid customerId or productId" });
    }
    next(err);
  }
}


function isUuid(s) {
  return typeof s === "string" &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(s);
}

function parseIsoDate(s) {
  if (typeof s !== "string") return null;
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? null : d;
}

module.exports = {
  viewAllOrders,
  viewOrderDetailAll,
  getOrderDetailsByInvoiceNumber,
  createNewOrder,
};
