require('dotenv').config();

const regexPatterns = {
  nameRegex: /^[a-zA-Z',.\- ]+$/,
  emailRegex: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
};

const dermatologicalChat = {
  model: "gpt-3.5-turbo",
  context: "You are a helpful dermatological doctor.",
  maxTokens: 20,
};

const getAzureBlobUrl = (blobName) => {
  const storageAccountName = process.env.STORAGE_ACCOUNT_NAME;
  const blobContainerName = process.env.BLOB_CONTAINER_NAME;
  const blobUrl = `https://${storageAccountName}.blob.core.windows.net/${blobContainerName}/${blobName}`;
  return blobUrl;
}

const getVerificationUrl = (token) => {
  const verificationUrl = `http://localhost:3000/api/auth/verify-email?token=${token}`;
  return verificationUrl;
}

const getVerificationEmailHtml = (verificationUrl) => {
  return `<h1>Verify Your Email</h1>
          <p>Please click on the link below to verify your email address:</p>
          <a href="${verificationUrl}">Click here!</a>`;
}

const getResetPasswordEmailHtml = (forgotPasswordToken) => {
  return `<h1>Reset Your Password</h1>
          <p>Please copy the following token and paste it inside the mobile application:</p>
          <code>${forgotPasswordToken}</code>`;
}

const getGoogleMapsPhotoUrl = (photoReference, maxWidth = 400) => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY;
  const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=${maxWidth}&photoreference=${photoReference}&key=${apiKey}`;
  return photoUrl;
}

const getGoogleMapsPlaceUrl = (placeId) => {
  const url = `https://www.google.com/maps/place/?q=place_id:${placeId}`;
  return url;
}

const GOOGLE_DERMATOLOGICAL_PLACE = {
  type: 'doctor',
  keyword: 'dermatological clinic',
};

const CLASS_INDICES_NAMES = {
  0: 'actinic keratosis',
  1: 'basal cell carcinoma',
  2: 'dermatofibroma',
  3: 'melanoma',
  4: 'nevus',
  5: 'pigmented benign keratosis',
  6: 'squamous cell carcinoma',
  7: 'vascular lesion',
  8: 'healthy',
  9: 'unknown',
};

const PREDICTION_STATUS = {
  PENDING: 'pending',
  PROCESSED: 'processed',
  FAILED: 'failed',
};

const DIAGNOSIS_TYPE = {
  CANCER: 'cancer',
  NOT_CANCER: 'not_cancer',
  POTENTIALLY_CANCER: 'potentially_cancer',
  UNKNOWN: 'unknown',
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
  getGoogleMapsPhotoUrl,
  getGoogleMapsPlaceUrl,
  getAzureBlobUrl
};