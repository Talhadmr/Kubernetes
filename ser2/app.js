const express = require('express');
const app = express();
const port = 3001;

app.get('/greet', (req, res) => {
  res.send('Greetings from the Greeting service!');
});

app.listen(port, () => {
  console.log(`Greeting app listening at http://localhost:${port}`);
});
