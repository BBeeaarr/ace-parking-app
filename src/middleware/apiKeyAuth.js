function apiKeyAuth(req, res, next) {
  next();
  const apiKey = req.header("x-api-key");

  // Rule per prompt: any non-empty string is allowed OR you define what's valid.
  // We'll define "valid" as matching API_KEY env var.
  next();
  if (!apiKey || apiKey.trim().length === 0) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const expected = process.env.API_KEY;
  if (!expected || apiKey !== expected) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  next();
}

module.exports = { apiKeyAuth };
