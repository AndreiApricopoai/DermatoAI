import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_verified_status_response.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class UserApi {
  static Future<GetProfileResponse> getProfileInformation() async {
    try {
      request() async {
        final url = BaseApi.getUri('profile/me');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetProfileResponse getProfileResponse =
          GetProfileResponse.fromJson(jsonResponse);
      return getProfileResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not get profile information. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<bool> setInitialProfileInformation() async {
    try {
      request() async {
        final url = BaseApi.getUri('profile/me');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetProfileResponse getProfileResponse =
          GetProfileResponse.fromJson(jsonResponse);

      if (getProfileResponse.isSuccess == true) {
        if (getProfileResponse.firstName != null) {
          SessionManager.setFirstName(getProfileResponse.firstName!);
        }
        if (getProfileResponse.lastName != null) {
          SessionManager.setLastName(getProfileResponse.lastName!);
        }
        if (getProfileResponse.email != null) {
          SessionManager.setEmail(getProfileResponse.email!);
        }
        if (getProfileResponse.profilePhoto != null) {
          SessionManager.setProfilePhoto(getProfileResponse.profilePhoto!);
        }
        if (getProfileResponse.verified != null) {
          SessionManager.setVerified(getProfileResponse.verified!);
        }
        if (getProfileResponse.isGoogleUser != null) {
          SessionManager.setIsGoogleUser(getProfileResponse.isGoogleUser!);
        }
        return true;
      }
      return false;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not get profile information. Please try again later to connect to your account.');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetVerifiedStatusResponse> getVerifiedStatus() async {
    try {
      request() async {
        final url = BaseApi.getUri('profile/me/verified');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetVerifiedStatusResponse getVerifiedStatusResponse =
          GetVerifiedStatusResponse.fromJson(jsonResponse);
      return getVerifiedStatusResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get verified status. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
