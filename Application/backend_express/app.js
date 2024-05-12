require('dotenv').config();
const express = require('express');
const passportConfig = require('./src/config/passportConfig');
const userRoutes = require('./src/routes/userRoutes');
const authRoutes = require('./src/routes/authRoutes');
const predictionRoutes = require('./src/routes/predictionRoutes');
const conversationRoutes = require('./src/routes/conversationRoutes');
const locationRoutes = require('./src/routes/locationRoutes');
const appointmentRoutes = require('./src/routes/appointmentRoutes');
const feedbackRoutes = require('./src/routes/feedbackRoutes');
const ApiResponse = require('./src/responses/apiResponse');

const app = express();

//middlewares
app.use(express.json());
app.use(express.static('./src/public'));
app.use(passportConfig.initialize());

//routes
app.get('/', (req, res) => { ApiResponse.success(res, { data: { message: "Welcome to DermatoAI API" } }) });
app.use('/api/auth', authRoutes);
app.use('/api/profile', userRoutes);
app.use('/api/predictions', predictionRoutes);
app.use('/api/conversations', conversationRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/feedbacks', feedbackRoutes);

module.exports = app;