class SessionManager {
  static String? _refreshToken;
  static String? _accessToken;
  static String? _firstName;
  static String? _lastName;
  static String? _email;
  static String? _profilePhoto;
  static bool? _verified;
  static bool? _isGoogleUser;

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

  static void setFirstName(String firstName) {
    _firstName = firstName;
  }

  static String? getFirstName() {
    return _firstName;
  }

  static void setLastName(String lastName) {
    _lastName = lastName;
  }

  static String? getLastName() {
    return _lastName;
  }

  static void setEmail(String email) {
    _email = email;
  }

  static String? getEmail() {
    return _email;
  }

  static void setProfilePhoto(String profilePhoto) {
    _profilePhoto = profilePhoto;
  }

  static String? getProfilePhoto() {
    return _profilePhoto;
  }

  static void setVerified(bool verified) {
    _verified = verified;
  }

  static bool? getVerified() {
    return _verified;
  }

  static void setIsGoogleUser(bool isGoogleUser) {
    _isGoogleUser = isGoogleUser;
  }

  static bool? getIsGoogleUser() {
    return _isGoogleUser;
  }

  static void clearSession() {
    _accessToken = null;
    _refreshToken = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _profilePhoto = null;
    _verified = null;
    _isGoogleUser = null;
  }
}
