require("dotenv").config();
const GoogleStrategy = require("passport-google-oauth20").Strategy;
const User = require("../models/userModel");
const passport = require("passport");
const { GoogleMessages } = require("../responses/apiConstants");

const verifyCallback = async (
  accessToken,
  refreshToken,
  profile,
  done,
  action
) => {
  if (!profile.emails || profile.emails.length === 0) {
    return done(null, false, {
      message: GoogleMessages.NoEmail,
    });
  }
  const email = profile.emails[0].value;
  const googleId = profile.id;
  const profilePhoto = profile.photos ? profile.photos[0].value : null;

  try {
    let user = await User.findOne({ email: email });

    if (action === "login") {
      if (!user) {
        return done(null, false, { message: GoogleMessages.UserNotFound });
      }
    } else if (action === "register") {
      if (user) {
        return done(null, false, { message: GoogleMessages.UserExists });
      }

      user = await User.create({
        firstName: profile.name.givenName,
        lastName: profile.name.familyName,
        email: email,
        googleId: googleId,
        profilePhoto: profilePhoto,
        verified: true,
      });
    }
    return done(null, user);
  } catch (error) {
    console.error("Error in verifyCallback:", error);
    return done(null, false, {
      message: GoogleMessages.Error,
    });
  }
};

passport.use(
  "google-login",
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "/api/auth/google/login/callback",
    },
    (accessToken, refreshToken, profile, done) => {
      verifyCallback(accessToken, refreshToken, profile, done, "login");
    }
  )
);

passport.use(
  "google-register",
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "/api/auth/google/register/callback",
    },
    (accessToken, refreshToken, profile, done) => {
      verifyCallback(accessToken, refreshToken, profile, done, "register");
    }
  )
);

module.exports = passport;