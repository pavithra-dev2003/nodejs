// Import Express module , This is a simple Express server that responds to HTTP requests.
const express = require('express');
const app = express();
const port = 3000;

// Define a route
app.get('/', (req, res) => {
  res.send('Hello, its new instruction');
});

// Start the server
app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});
