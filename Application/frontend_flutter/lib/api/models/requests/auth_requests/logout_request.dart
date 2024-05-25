import 'dart:convert';

class LogoutRequest {
  final String refreshToken;

  LogoutRequest({
    required this.refreshToken,
  });

  String toJson() {
    return json.encode({
      'refreshToken': refreshToken,
    });
  }
}
