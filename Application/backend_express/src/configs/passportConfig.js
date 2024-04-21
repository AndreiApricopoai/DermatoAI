// src/config/passportConfig.js
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const User = require('../models/user'); // Your User model

const verifyCallback = async (accessToken, refreshToken, profile, done, action) => {
  const email = profile.emails[0].value;
  try {
    let user = await User.findOne({ email: email });
    
    if (action === 'login') {
      if (!user) {
        return done(null, false, { message: 'User not found' });
      }
    } else if (action === 'register') {
      if (user) {
        return done(null, false, { message: 'User already exists' });
      }
      user = await User.create({
        googleId: profile.id,
        email: email,
        firstName: profile.name.givenName,
        lastName: profile.name.familyName
      });
    }

    return done(null, user);
  } catch (error) {
    return done(error, false);
  }
};

passport.use('google-login', new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: "/auth/google/login/callback"
  },
  (accessToken, refreshToken, profile, done) => {
    verifyCallback(accessToken, refreshToken, profile, done, 'login');
  }
));

passport.use('google-register', new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: "/auth/google/register/callback"
  },
  (accessToken, refreshToken, profile, done) => {
    verifyCallback(accessToken, refreshToken, profile, done, 'register');
  }
));

module.exports = passport;
