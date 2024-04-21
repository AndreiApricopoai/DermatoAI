// src/middlewares/authMiddleware.js

const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  // Assume the token is sent in the Authorization header as "Bearer <token>"
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Authentication token is missing or invalid' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.ACCES_TOKEN_SECRET);
    req.user = decoded; // Assign the payload to req.user
    next();
  } catch (error) {
    return res.status(403).json({ message: 'Authentication failed' });
  }
};

module.exports = authMiddleware;
