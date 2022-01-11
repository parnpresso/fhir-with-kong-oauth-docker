const express = require('express');

const app = express();

app.get('/', (req, res) => res.send({ message: 'hello!' }));

app.listen(3000);
