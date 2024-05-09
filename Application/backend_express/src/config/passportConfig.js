const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const User = require('../models/userModel');
require('dotenv').config();

const verifyCallback = async (accessToken, refreshToken, profile, done, action) => {
  if (!profile.emails || profile.emails.length === 0) {
    return done(null, false, { message: 'No email found from Google profile.' });
  }
  const email = profile.emails[0].value;
  const googleId = profile.id;

  try {
    let user = await User.findOne({ email: email });

    if (action === 'login') {
      // Login action
      if (!user) {
        return done(null, false, { message: 'User not found' });
      }
    } else if (action === 'register') {
      // Register action
      if (user) {
        return done(null, false, { message: 'User already exists' });
      }
      user = await User.create({
        firstName: profile.name.givenName,
        lastName: profile.name.familyName,
        email: email,
        googleId: googleId
      });
    }
    return done(null, user);
  }
  catch (error) {
    console.error('Error in verifyCallback:', error);
    return done(null, false, { message: 'An error occurred while processing your google request. Please try again.' });
  }
};

passport.use('google-login', new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: "/api/auth/google/login/callback"
},
  (accessToken, refreshToken, profile, done) => {
    verifyCallback(accessToken, refreshToken, profile, done, 'login');
  }
));

passport.use('google-register', new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: "/api/auth/google/register/callback"
},
  (accessToken, refreshToken, profile, done) => {
    verifyCallback(accessToken, refreshToken, profile, done, 'register');
  }
));

module.exports = passport;