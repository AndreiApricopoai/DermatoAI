require("dotenv").config();
const nodemailer = require("nodemailer");
const nodemailerSendgrid = require("nodemailer-sendgrid");

const transport = nodemailer.createTransport(
  nodemailerSendgrid({
    apiKey: process.env.SENDGRID_API_KEY,
  })
);

const sendEmail = async (receiverEmail, subject, html) => {
  try {
    await transport.sendMail({
      from: process.env.SENDER_EMAIL,
      to: receiverEmail,
      subject,
      html,
    });
    return true;
  } catch (error) {
    console.error("Failed to send email:", error);
    return false;
  }
};

module.exports = { sendEmail };
