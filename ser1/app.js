const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

app.get('/', async (req, res) => {
  try {
    const response = await axios.get('http://greeting-service:3001/greet');
    res.send(`Hello World! ${response.data}`);
  } catch (error) {
    res.send('Hello World! Greeting service is not available.');
  }
});

app.listen(port, () => {
  console.log(`Hello World app listening at http://localhost:${port}`);
});
