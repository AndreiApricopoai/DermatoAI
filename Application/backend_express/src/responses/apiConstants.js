const StatusCodes = {
  Ok: 200,
  Created: 201,
  NoContent: 204,
  BadRequest: 400,
  Unauthorized: 401,
  Forbidden: 403,
  NotFound: 404,
  InternalServerError: 500
};

const UserMessages = {
  NotFound: 'User not found.',
  Exists: 'User already exists.',
  Created: 'User created successfully.',
  Updated: 'User updated successfully.',
  Deleted: 'User deleted successfully.'
};

const GoogleMessages = {
  Succes: 'Google authentication successful.',
  NoEmail: 'No email found from Google profile.',
  UserNotFound: 'User not found.',
  UserExists: 'User already exists.',
  AuthFailed: 'Google authentication failed. Please try again.',
  Error: 'An error occurred while processing your google request. Please try again.'
};

const AuthMessages = {
  LoginSuccess: 'Login successful.',
  RegisterSuccess: 'Registration successful.',
  LogoutSuccess: 'Logout successful.',
  UnexpectedErrorLogin: 'An unexpected error occurred during login. Please try again later.',
  UnexpectedErrorRegister: 'An unexpected error occurred during registration. Please try again later.',
  UnexpectedErrorLogout: 'An unexpected error occurred during logout. Please try again later.',
  UnexpectedErrorGetAccessToken: 'An unexpected error occurred during access token retrieval. Please try again later.',
  UnexpectedErrorSendVerificationEmail: 'An unexpected error occurred during email verification. Please try again later.',
  UnexpectedErrorVerifyEmail: 'An unexpected error occurred during email verification. Please try again later.',
  UnexpectedErrorPasswordChange: 'An unexpected error occurred during password change. Please try again later.',
  UnexpectedErrorForgotPassword: 'An unexpected error occurred during password reset. Please try again later.',
  UnexpectedErrorResetPassword: 'An unexpected error occurred during password reset. Please try again later.',
};

const ErrorMessages = {
  FetchError: 'Failed to fetch data.',
  NotFound: 'The requested resource was not found.',
  ServerError: 'Internal server error occurred.',
  Unauthorized: 'You are not authorized to view this resource.',
  ValidationError: 'Validation failed for the provided input.',

  UnexpectedErrorGet: 'An unexpected error occurred while fetching data.',
  UnexpectedErrorGetAll: 'An unexpected error occurred while fetching all data.',
  UnexpectedErrorCreate: 'An unexpected error occurred while creating the resource.',
  UnexpectedErrorUpdate: 'An unexpected error occurred while updating the resource.',
  UnexpectedErrorDelete: 'An unexpected error occurred while deleting the resource.',
  UnexpectedError: 'An unexpected error occurred. Please try again later.',
};


module.exports = {
  StatusCodes,
  UserMessages,
  GoogleMessages,
  AuthMessages,
  ErrorMessages
};