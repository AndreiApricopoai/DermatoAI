require('dotenv').config();
const express = require('express');
const passportConfig = require('./src/configs/passportConfig');
const userRoutes = require('./src/routes/userRoutes');
const authRoutes = require('./src/routes/authRoutes');
const ApiResponse = require('./src/responses/apiResponse');

const app = express();

//middlewares
app.use(express.json());
app.use(passportConfig.initialize());

//routes
app.use('/', (req, res) => { ApiResponse.success(res, { data: { message: "Welcome to DermatoAI API" } }) });
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);

module.exports = app;