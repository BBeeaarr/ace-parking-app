const express = require("express");
const { notFoundHandler, errorHandler } = require("./middleware/errorHandler");


function createApp() {
  const app = express();

  app.use(express.json({ limit: "1mb" }));

  // 404 + error middleware
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}

module.exports = { createApp };
