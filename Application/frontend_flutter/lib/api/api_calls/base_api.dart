import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/utils/constants.dart';

class BaseApi {
  static const String _baseUrl = ApiConstants.baseUrl;
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };
  
  static Uri getUri(String endpoint) {
    return Uri.parse('$_baseUrl$endpoint');
  }

  static Map<String, String> getHeaders() {
    return _headers;
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
}
