const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  firstName: { type: String, required: true, trim: true },
  lastName: { type: String, required: true, trim: true },
  email: { type: String, required: true, trim: true, unique: true },
  passwordHash: { type: String },
  salt: { type: String, unique: true },
  googleId: { type: String, unique: true }, // for storing Google's user identifier
});

userSchema.pre('save', async function(next) {
  if (this.passwordHash && this.isModified('passwordHash')) {
    this.salt = await bcrypt.genSalt();
    this.passwordHash = await bcrypt.hash(this.passwordHash, this.salt);
  }
  next();
});

userSchema.methods.validatePassword = async function(password) {
  return bcrypt.compare(password, this.passwordHash);
};

const User = mongoose.model('User', userSchema);

module.exports = User;
