const StatusCodes = {
  Ok: 200,
  Created: 201,
  Accepted: 202,
  NoContent: 204,
  BadRequest: 400,
  Unauthorized: 401,
  Forbidden: 403,
  NotFound: 404,
  InternalServerError: 500,
};

const ResponseTypes = {
  Success: "success",
  Error: "error",
  ValidationError: "validationError",
};

const UserMessages = {
  NotFound: "User not found.",
  InvalidPassword: "Invalid password.",
  UserEmailNotExists: "User with this email does not exist.",
  Exists: "User already exists.",
  InvalidEmail: "Invalid email.",
  UserAlreadyVerified: "User is already verified.",
  FailedRetrieve: "Failed to retrieve user information.",
  Created: "User created successfully.",
  Updated: "User updated successfully.",
  Deleted: "User deleted successfully.",
};

const GoogleMessages = {
  Success: "Google authentication successful.",
  NoEmail: "No email found from Google profile.",
  UserNotFound: "User not found.",
  UserExists: "User already exists.",
  ChangePasswordFromGoogle:
    "User with this email exists. Please change your password from Google.",
  ResetPasswordFromGoogle:
    "User with this email exists. Please reset your password from Google.",
  UserExistsLogin:
    "Google user with this email exists. Please login with Google.",
  AuthFailed: "Google authentication failed. Please try again.",
  Error:
    "An error occurred while processing your google request. Please try again.",
};

const AuthMessages = {
  LoginSuccess: "Login successful.",
  RegisterSuccess: "Registration successful.",
  LogoutSuccess: "Logout successful.",
  InvalidOldPassword: "Invalid old password.",
  PasswordChanged: "Password changed successfully.",
  EmailVerificationSent: "Email verification sent successfully.",
  EmailVerified: "Email verified successfully.",
  EmailSendError: "Failed to send email verification.",
  ForgotPasswordEmailFailed: "Failed to send forgot password email.",
  ForgotPasswordEmailSent: "Forgot password email sent successfully.",
  PasswordResetSuccess: "Password reset successful.",
  UnexpectedErrorLogin:
    "An unexpected error occurred during login. Please try again later.",
  UnexpectedErrorRegister:
    "An unexpected error occurred during registration. Please try again later.",
  UnexpectedErrorLogout:
    "An unexpected error occurred during logout. Please try again later.",
  UnexpectedErrorGetAccessToken:
    "An unexpected error occurred during access token retrieval. Please try again later.",
  UnexpectedErrorSendVerificationEmail:
    "An unexpected error occurred during email verification. Please try again later.",
  UnexpectedErrorVerifyEmail:
    "An unexpected error occurred during email verification. Please try again later.",
  UnexpectedErrorPasswordChange:
    "An unexpected error occurred during password change. Please try again later.",
  UnexpectedErrorForgotPassword:
    "An unexpected error occurred during password reset. Please try again later.",
  UnexpectedErrorResetPassword:
    "An unexpected error occurred during password reset. Please try again later.",
};

const ErrorMessages = {
  FetchError: "Failed to fetch data.",
  NotFound: "The requested resource was not found.",
  ServerError: "Internal server error occurred.",
  Unauthorized: "You are not authorized to view this resource.",
  ValidationError: "Validation failed for the provided input.",
  CreateError: "Failed to create the resource.",
  UpdateError: "Failed to update the resource.",
  DeleteError: "Failed to delete the resource.",
  UnexpectedErrorGet: "An unexpected error occurred while fetching data.",
  UnexpectedErrorGetAll:
    "An unexpected error occurred while fetching all data.",
  UnexpectedErrorCreate:
    "An unexpected error occurred while creating the resource.",
  UnexpectedErrorUpdate:
    "An unexpected error occurred while updating the resource.",
  UnexpectedErrorDelete:
    "An unexpected error occurred while deleting the resource.",
  UnexpectedError: "An unexpected error occurred. Please try again later.",
  ResponseNotHandled: "Response not handled by the server.",
};

const PredictionMessages = {
  Created: "Prediction created successfully and added to queue for processing.",
  RollbackFailed:
    "An unexpected error occurred during prediction creation and operation rollback failed. Please try again later.",
  RollbackSucceeded:
    "An unexpected error occurred during prediction creation and operation rollback succeeded. Please try again later.",
};

const TokenMessages = {
  TokenCreationSuccess: "Token created successfully.",
  TokenRefreshed: "Token refreshed successfully.",
  MissingAccessToken: "Access token is missing or invalid.",
  TokenCreationError: "Failed to create token.",
  TokenExpired: "Token has expired.",
  TokenPayloadInvalid: "Token payload is invalid.",
  NoTokenFound: "No token found. Perhaps the user is already logged out.",
  UnauthorizedToken: "Unauthorized token.",
  FailedSavingToken: "Failed to save token.",
  UnexpectedError: "An unexpected error occurred during token processing.",
};

const ImageUploadMessages = {
  LimitUnexpectedFile: "Only one image is allowed.",
  LimitFileSize: "The image size must be less than 10MB.",
  UnexpectedError:
    "An unexpected error occurred during image upload. Please try again later.",
  NoImageUploaded: "No image uploaded.",
  InvalidImage:
    "Image must be at least 600x450 pixels, approximately a 4:3 aspect ratio.",
  ValidationFailed: "Image validation failed.",
};

const MongooseMessages = {
  CastError: "Invalid object ID.",
  ValidationError: "Validation failed.",
  MissingID: "Missing required ID query parameter.",
  UnexpectedError: "An unexpected error occurred. Please try again later.",
};

const WelcomeMessage = "Welcome to DermatoAI API";
const EndpointNotFound = "Endpoint not found.";

module.exports = {
  StatusCodes,
  UserMessages,
  GoogleMessages,
  AuthMessages,
  ErrorMessages,
  TokenMessages,
  ImageUploadMessages,
  MongooseMessages,
  WelcomeMessage,
  ResponseTypes,
  PredictionMessages,
  EndpointNotFound,
};
