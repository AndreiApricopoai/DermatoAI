import 'package:frontend_flutter/api/models/requests/auth_requests/change_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/get_access_token_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/login_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/logout_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/register_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/reset_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_forgot_password_email_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_verification_email_request.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/change_password_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/get_acces_token_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/login_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/logout_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/register_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/reset_password_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/send_forgot_password_email_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/send_verification_email_response.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class AuthApi {
  static Future<LoginResponse> login(
      LoginRequest loginRequest, bool rememberMe) async {
    try {
      final url = BaseApi.getUri('auth/login');
      final body = loginRequest.toJson();
      final headers = BaseApi.getHeaders();

      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      LoginResponse loginResponse = LoginResponse.fromJson(jsonResponse);

      if (loginResponse.isSuccess) {
        final refreshToken = loginResponse.refreshToken;
        final accesToken = loginResponse.token;

        if (refreshToken != null && refreshToken.isNotEmpty) {
          if (rememberMe) {
            await LocalStorage.saveRefreshToken(refreshToken);
          }
          SessionManager.setRefreshToken(refreshToken);
        }
        if (accesToken != null && accesToken.isNotEmpty) {
          SessionManager.setAccessToken(accesToken);
        }
      }
      return loginResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not login. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      await LocalStorage.clearRefreshToken();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<RegisterResponse> register(
      RegisterRequest registerRequest) async {
    try {
      final url = BaseApi.getUri('auth/register');
      final body = registerRequest.toJson();
      final headers = BaseApi.getHeaders();

      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      RegisterResponse registerResponse =
          RegisterResponse.fromJson(jsonResponse);

      if (registerResponse.isSuccess) {
        final refreshToken = registerResponse.refreshToken;
        final accessToken = registerResponse.token;

        if (refreshToken != null && refreshToken.isNotEmpty) {
          SessionManager.setRefreshToken(refreshToken);
        }
        if (accessToken != null && accessToken.isNotEmpty) {
          SessionManager.setAccessToken(accessToken);
        }
      }
      return registerResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not register you. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<LogoutResponse> logout(LogoutRequest logoutRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('auth/logout');
        final body = jsonEncode(logoutRequest.toJson());
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.delete(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      LogoutResponse logoutResponse = LogoutResponse.fromJson(jsonResponse);

      if (logoutResponse.isSuccess) {
        SessionManager.clearSession();
        await LocalStorage.clearRefreshToken();
      }
      return logoutResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not log out. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      await LocalStorage.clearRefreshToken();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetAccesTokenResponse> getAccessToken(
      GetAccessTokenRequest getAccessTokenRequest) async {
    try {
      final url = BaseApi.getUri('auth/token');
      final body = getAccessTokenRequest.toJson();
      final headers = BaseApi.getHeaders();

      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      GetAccesTokenResponse getAccesTokenResponse =
          GetAccesTokenResponse.fromJson(jsonResponse);

      if (getAccesTokenResponse.isSuccess) {
        final newAccessToken = getAccesTokenResponse.token;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          SessionManager.setAccessToken(newAccessToken);
        }
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        SessionManager.clearSession();
        await LocalStorage.clearRefreshToken();
      }
      return getAccesTokenResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get access token. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<SendVerificationEmailResponse> sendVerificationEmail(
      SendVerificationEmailRequest sendVerificationEmailRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('auth/send-verification-email');
        final body = jsonEncode(sendVerificationEmailRequest.toJson());
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      SendVerificationEmailResponse sendVerificationEmailResponse =
          SendVerificationEmailResponse.fromJson(jsonResponse);

      return sendVerificationEmailResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not send verification email. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      await LocalStorage.clearRefreshToken();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('auth/change-password');
        final body = jsonEncode(changePasswordRequest.toJson());
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      ChangePasswordResponse changePasswordResponse =
          ChangePasswordResponse.fromJson(jsonResponse);

      return changePasswordResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not change password. Please check your current password and try again');
    } on Exception {
      SessionManager.clearSession();
      await LocalStorage.clearRefreshToken();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<SendForgotPasswordEmailResponse> sendForgotPasswordEmail(
      SendForgotPasswordEmailRequest sendForgotPasswordEmailRequest) async {
    try {
      final url = BaseApi.getUri('auth/send-forgot-password-email');
      final body = sendForgotPasswordEmailRequest.toJson();
      final headers = BaseApi.getHeaders();

      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      SendForgotPasswordEmailResponse sendForgotPasswordEmailResponse =
          SendForgotPasswordEmailResponse.fromJson(jsonResponse);

      return sendForgotPasswordEmailResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not send forgot password email. Please try again');
    } on Exception {
      SessionManager.clearSession();
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest resetPasswordRequest) async {
    try {
      final url = BaseApi.getUri('auth/reset-password');
      final body = resetPasswordRequest.toJson();
      final headers = BaseApi.getHeaders();

      var response = await http.post(url, headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);
      ResetPasswordResponse resetPasswordResponse =
          ResetPasswordResponse.fromJson(jsonResponse);

      return resetPasswordResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not reset password. Please try again later');
    } on Exception {
      SessionManager.clearSession();
      throw Exception('Unexpected error occurred');
    }
  }
}
