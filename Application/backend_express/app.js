require('dotenv').config();
const express = require('express');
const passportConfig = require('./src/config/passportConfig');
const userRoutes = require('./src/routes/userRoutes');
const authRoutes = require('./src/routes/authRoutes');
const predictionRoutes = require('./src/routes/predictionRoutes');
const conversationRoutes = require('./src/routes/conversationRoutes');
const locationRoutes = require('./src/routes/locationRoutes');
const ApiResponse = require('./src/responses/apiResponse');

const app = express();

//middlewares
app.use(express.json());
app.use(passportConfig.initialize());

//routes
app.get('/', (req, res) => { ApiResponse.success(res, { data: { message: "Welcome to DermatoAI API" } }) });
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/predictions', predictionRoutes);
app.use('/api/conversations', conversationRoutes);
app.use('/api/locations', locationRoutes);

module.exports = app;