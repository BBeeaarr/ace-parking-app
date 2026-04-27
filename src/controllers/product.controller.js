const { getPool } = require("../db/pool");

async function viewAllProducts(req, res, next) {
  try {
    const pool = await getPool();

    const result = await pool.request().query(`
      SELECT
        productId = p.product_id,
        productName = p.product_name,
        productCost = p.product_cost
      FROM products p
      ORDER BY p.product_name
    `);
    console.log("viewAllProducts called");
    console.log(req.body);

    res.json(result.recordset);
  } catch (err) {
    next(err);
  }
}

module.exports = { viewAllProducts };
