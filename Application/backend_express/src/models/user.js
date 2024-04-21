const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const nameValidator = /^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$/;
const emailValidator = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

const userSchema = new mongoose.Schema({
  firstName: { 
    type: String,
    required: [true, "First name is required"], 
    trim: true,
    minlength: [2, "First name is too short"],
    maxlength: [50, "First name is too long"],
    match: [nameValidator, "First name is not valid"],
  },
  lastName: { 
    type: String, 
    required: [true, "Last name is required"], 
    trim: true,
    minlength: [2, "Last name is too short"],
    maxlength: [50, "Last name is too long"],
    match: [nameValidator, "Last name is not valid"],
   },
  email: { 
    type: String, 
    required: [true, "Email is required"], 
    trim: true, 
    unique: [true, "Email already exists"],
    lowercase: true,
    match: [emailValidator, "Email is not valid"]
  },
  passwordHash: { 
    type: String 
  },
  googleId: { 
    type: String, 
    unique: [true, "Google ID already exists"] 
  },
}, {
  collection: 'users',
  timestamps: true
});

userSchema.pre('save', async function(next) {
  // Only hash the password if it has been modified (or is new)
  if (this.isModified('passwordHash')) {
    // Automatically generates a salt and hashes the incoming password
    this.passwordHash = await bcrypt.hash(this.passwordHash, 10);
  }
  next();
});

userSchema.methods.validatePassword = async function(password) {
  return bcrypt.compare(password, this.passwordHash);
};

const User = mongoose.model('User', userSchema);

module.exports = User;
