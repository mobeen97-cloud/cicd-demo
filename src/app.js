// The Express app is defined here (separately from server.js)
// so tests can import it without starting a real server.
const express = require('express');

const app = express();

// Health check: used by Docker and our smoke test to know the app is alive.
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Simple business logic we can test: /add?a=2&b=3 -> { result: 5 }
app.get('/add', (req, res) => {
  const a = Number(req.query.a);
  const b = Number(req.query.b);
  if (Number.isNaN(a) || Number.isNaN(b)) {
    return res.status(400).json({ error: 'a and b must be numbers' });
  }
  res.json({ result: a + b });
});

module.exports = app;
