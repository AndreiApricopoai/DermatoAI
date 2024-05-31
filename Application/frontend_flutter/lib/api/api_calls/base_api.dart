import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/api_constants.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/get_access_token_request.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  static Uri getUri(String endpoint) {
    var baseUrlApi = ApiConstants.baseUrlApi;
    return Uri.parse('$baseUrlApi$endpoint');
  }

  static Uri getUriWithQueryParameters(String endpoint, Map<String, String> queryParameters) {
    var baseUrlApi = ApiConstants.baseUrlApi;
    return Uri.parse('$baseUrlApi$endpoint').replace(queryParameters: queryParameters);
  }

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Map<String, String> getHeadersWithAuthorization() {
    String? accessToken = SessionManager.getAccessToken();
    if (accessToken == null) {
      throw Exception('You must be logged in to perform this action.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

    static Map<String, String> getAuthorizationHeaders() {
    String? accessToken = SessionManager.getAccessToken();
    if (accessToken == null) {
      throw Exception('You must be logged in to perform this action.');
    }
    return {
      'Authorization': 'Bearer $accessToken',
    };
  }

  static Future<http.Response> performRequestWithRetry(
      Future<http.Response> Function() request) async {
    try {
      var response = await request();
      if (response.statusCode == 401 || response.statusCode == 403) {
        String? refreshToken = SessionManager.getRefreshToken();

        if (refreshToken == null) {
          throw Exception('You must be logged in to perform this action.');
        }
        GetAccessTokenRequest getAccessTokenRequest =
            GetAccessTokenRequest(refreshToken: refreshToken);
        await AuthApi.getAccessToken(getAccessTokenRequest);
        response = await request();
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
