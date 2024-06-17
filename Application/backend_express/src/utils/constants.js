require("dotenv").config();

const regexPatterns = {
  nameRegex: /^[a-zA-Z]+([ \-][a-zA-Z]+)*$/,
  emailRegex: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
};

const dermatologicalChat = {
  model: "gpt-3.5-turbo",
  context: "You are a helpful dermatological doctor.",
  maxTokens: 350,
};

const getAzureBlobUrl = (blobName) => {
  const storageAccountName = process.env.STORAGE_ACCOUNT_NAME;
  const blobContainerName = process.env.BLOB_CONTAINER_NAME;
  const blobUrl = `https://${storageAccountName}.blob.core.windows.net/${blobContainerName}/${blobName}`;
  return blobUrl;
};

const getAzureBlobSasUrl = (blobUrl) => {
  const sas_token = process.env.BLOB_SAS_TOKEN;
  return blobUrl + "?" + sas_token;
};

const getVerificationUrl = (token) => {
  const verificationUrl = `http://192.168.100.7:3000/api/auth/verify-email?token=${token}`;
  return verificationUrl;
};

const getVerificationEmailHtml = (verificationUrl) => {
  return `
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body {
        font-family: 'Arial', sans-serif;
        background-color: #ffffff;
        color: #333333;
        padding: 20px;
        margin: 0;
      }
      h1 {
        color: #333333;
      }
      p {
        font-size: 16px;
      }
      a {
        color: #1a0dab;
        text-decoration: none;
      }
      a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <h1>Verify Your Email</h1>
    <p>Please click on the link below to verify your email address:</p>
    <a href="${verificationUrl}">Click here!</a>
  </body>
  </html>`;
};

const getResetPasswordEmailHtml = (forgotPasswordToken) => {
  return `
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body {
        font-family: 'Arial', sans-serif;
        background-color: #f4f4f9;
        color: #333;
        line-height: 1.6;
        padding: 20px;
      }
      h1 {
        color: #00457c;
      }
      p {
        font-size: 16px;
      }
      .token {
        font-size: 18px;
        font-weight: bold;
        background-color: #e8f0fe;
        border-left: 5px solid #304ffe;
        padding: 10px;
        margin: 20px 0px;
        word-wrap: break-word;
      }
      .info {
        margin-top: 20px;
      }
    </style>
  </head>
  <body>
    <h1>Reset Your Password</h1>
    <p class="info">Please copy the following token and paste it inside the mobile application:</p>
    <div class="token">${forgotPasswordToken}</div>
  </body>
  </html>`;
};

const getGoogleAuthRedirectUrl = (response) => {
  const redirectUrl = `yourapp://callback?response=${encodeURIComponent(JSON.stringify(response))}`;
  return `
    <!DOCTYPE html>
    <html lang="en">      
      <body>
        <script type="text/javascript">
          window.location.href = "${redirectUrl}";
          window.close();
          </script>
      </body>
    </html>
  `;
};

const getGoogleMapsPhotoUrl = (photoReference, maxWidth = 400) => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY;
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=${maxWidth}&photoreference=${photoReference}&key=${apiKey}`;
  return photoUrl;
};

const getGoogleMapsPlaceUrl = (placeId) => {
  const url = `https://www.google.com/maps/place/?q=place_id:${placeId}`;
  return url;
};

const GOOGLE_DERMATOLOGICAL_PLACE = {
  type: "doctor",
  keyword: "dermatological clinic",
};

const CLASS_INDICES_NAMES = {
  0: "actinic keratosis",
  1: "basal cell carcinoma",
  2: "dermatofibroma",
  3: "melanoma",
  4: "nevus",
  5: "pigmented benign keratosis",
  6: "squamous cell carcinoma",
  7: "vascular lesion",
  8: "healthy",
  9: "unknown",
};

const PREDICTION_STATUS = {
  PENDING: "pending",
  PROCESSED: "processed",
  FAILED: "failed",
};

const DIAGNOSIS_TYPE = {
  CANCER: "cancer",
  NOT_CANCER: "not_cancer",
  POTENTIALLY_CANCER: "potentially_cancer",
  UNKNOWN: "unknown",
};

module.exports = {
  regexPatterns,
  dermatologicalChat,
  GOOGLE_DERMATOLOGICAL_PLACE,
  CLASS_INDICES_NAMES,
  PREDICTION_STATUS,
  DIAGNOSIS_TYPE,
  getVerificationUrl,
  getVerificationEmailHtml,
  getResetPasswordEmailHtml,
  getGoogleAuthRedirectUrl,
  getGoogleMapsPhotoUrl,
  getGoogleMapsPlaceUrl,
  getAzureBlobUrl,
  getAzureBlobSasUrl,
};
