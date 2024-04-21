// src/models/RefreshToken.js
const mongoose = require('mongoose');
const crypto = require('crypto');
require('dotenv').config();

const refreshTokenSchema = new mongoose.Schema({
    token: { type: String, required: true },
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    expires: { type: Date, required: true }
}, {
    collection: 'refreshTokens',
    timestamps: true
});

// Encrypt tokens before saving
refreshTokenSchema.pre('save', async function (next) {
    if (this.isModified('token')) {
        const iv = crypto.randomBytes(16);
        const cipher = crypto.createCipheriv('aes-256-ctr', Buffer.from(process.env.ENCRYPTION_KEY, 'hex'), iv);
        const encrypted = Buffer.concat([cipher.update(this.token), cipher.final()]);
        this.token = `${iv.toString('hex')}:${encrypted.toString('hex')}`;
    }
    next();
});

// Method to decrypt token
refreshTokenSchema.methods.decryptToken = function () {
    const tokenParts = this.token.split(':');
    const iv = Buffer.from(tokenParts.shift(), 'hex');
    const encryptedText = Buffer.from(tokenParts.join(':'), 'hex');
    const decipher = crypto.createDecipheriv('aes-256-ctr', Buffer.from(process.env.ENCRYPTION_KEY, 'hex'), iv);
    const decrypted = Buffer.concat([decipher.update(encryptedText), decipher.final()]);
    return decrypted.toString();
};

const RefreshToken = mongoose.model('RefreshToken', refreshTokenSchema);

module.exports = RefreshToken;
