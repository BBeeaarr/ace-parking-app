function notFoundHandler(req, res) {
  res.status(404).json({ message: "Not Found" });
}

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  
  console.error(err);

  // If a controller intentionally sets a status, respect it.
  const status = err.statusCode || 500;

  if (status === 500) {
    return res.status(500).json({ message: "Internal Server Error" });
  }

  return res.status(status).json({ message: err.message || "Error" });
}

module.exports = { notFoundHandler, errorHandler };
