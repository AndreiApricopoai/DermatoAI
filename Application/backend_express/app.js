const express = require('express');
const mongoose = require('mongoose');
const userRoutes = require('./src/routes/userRoutes');
const authMiddleware = require('./src/middlewares/authMiddleware');

const app = express();

//middlewares
app.use(express.json());
app.use(authMiddleware);


//routes
app.use('/api/users', userRoutes);

module.exports = app;



