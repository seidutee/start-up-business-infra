const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());

mongoose.connect('mongodb://mongo:27017/clothingdb', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.get('/', (req, res) => {
  res.send('Welcome to the female clothing store API');
});

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
