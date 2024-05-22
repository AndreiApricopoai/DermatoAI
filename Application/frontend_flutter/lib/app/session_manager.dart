class SessionManager {
  static String? _refreshToken;
  static String? _accessToken;

  static void setRefreshToken(String token) {
    _refreshToken = token;
  }

  static String? getRefreshToken() {
    return _refreshToken;
  }

  static void setAccessToken(String token) {
    _accessToken = token;
  }

  static String? getAccessToken() {
    return _accessToken;
  }

  static void clearSession() {
    _accessToken = null;
    _refreshToken = null;
  }
}
