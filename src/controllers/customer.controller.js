const { getPool } = require("../db/pool");

async function viewAllCustomers(req, res, next) {
  try {
    const pool = await getPool();

    // Adjust table/column names to match your init.sql.
    const result = await pool.request().query(`
      SELECT
        customerId   = c.customer_id,
        customerName = c.customer_name,
        customerAddress1 = c.customer_address1,
        customerAddress2 = c.customer_address2,
        customerCity = c.customer_city,
        customerState = c.customer_state,
        customerPostalCode = c.customer_postal_code,
        customerTelephone = c.customer_telephone,
        customerContactName = c.customer_contact_name,
        customerEmailAddress = c.customer_email_address
      FROM customers c
      ORDER BY c.customer_name
    `);

    res.json(result.recordset);
  } catch (err) {
    next(err);
  }
}

module.exports = { viewAllCustomers };
