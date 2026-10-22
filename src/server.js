// Entry point: starts the HTTP server.
const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`cicd-demo listening on http://localhost:${PORT}`);
});
