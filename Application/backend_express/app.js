const express = require('express');
const mongoose = require('mongoose');
const passportConfig = require('./src/configs/passportConfig');
const userRoutes = require('./src/routes/userRoutes');
const authRoutes = require('./src/routes/authRoutes');
const authMiddleware = require('./src/middlewares/authMiddleware');


require('dotenv').config();





const app = express();

//middlewares
app.use(express.json());

app.use(passportConfig.initialize());

//app.use(authMiddleware);


//routes
//app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);


const users = [
    { id: 1, name: 'John Doe' },
    { id: 2, name: 'Jane Doe' },
    { id: 3, name: 'John Smith' }
]

app.get('/users', (req, res) => {
  res.json(users);
});

module.exports = app;



