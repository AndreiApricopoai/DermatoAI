import 'package:frontend_flutter/api/models/requests/login_request.dart';
import 'package:frontend_flutter/api/models/responses/login_response.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthApi {
  static Future<LoginResponse> login(LoginRequest loginRequest, bool rememberMe) async {
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

  static Future<http.Response> register(String email, String password) async {
    var url = BaseApi.getUri('register');
    return await http.post(url, body: {
      'email': email,
      'password': password,
    });
  }

  static Future<http.Response> googleLogin(String token) async {
    var url = BaseApi.getUri('google-login');
    return await http.post(url, body: {
      'token': token,
    });
  }

  static Future<http.Response> googleRegister(String token) async {
    var url = BaseApi.getUri('google-login');
    return await http.post(url, body: {
      'token': token,
    });
  }

  static Future<http.Response> logout() async {
    var url = BaseApi.getUri('logout');
    return await http.post(url);
  }

  static Future<http.Response> getAccessToken() async {
    var url = BaseApi.getUri('get-access-token');
    return await http.post(url);
  }

  static Future<http.Response> sendVerificationEmail(String email) async {
    var url = BaseApi.getUri('send-verification-email');
    return await http.post(url, body: {
      'email': email,
    });
  }

  static Future<http.Response> changePassword(
      String oldPassword, String newPassword) async {
    var url = BaseApi.getUri('change-password');
    return await http.post(url, body: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  static Future<http.Response> sendForgotPasswordEmail(String email) async {
    var url = BaseApi.getUri('send-forgot-password-email');
    return await http.post(url, body: {
      'email': email,
    });
  }

  static Future<http.Response> resetPassword(String email) async {
    var url = BaseApi.getUri('reset-password');
    return await http.post(url, body: {
      'email': email,
    });
  }

  static void showErrorMessage(
      BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
