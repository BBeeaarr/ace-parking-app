const express = require("express");
const { notFoundHandler, errorHandler } = require("./middleware/errorHandler");

const publicRoutes = require("./routes/public.routes");

function createApp() {
  const app = express();

  app.use(express.json({ limit: "1mb" }));

	app.use("/api/public", publicRoutes);

  // 404 + error middleware
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}

module.exports = { createApp };
