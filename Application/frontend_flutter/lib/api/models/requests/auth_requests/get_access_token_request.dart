import 'dart:convert';

class GetAccessTokenRequest {
  final String refreshToken;

  GetAccessTokenRequest({
    required this.refreshToken,
  });

  String toJson() {
    return json.encode({
      'refreshToken': refreshToken,
    });
  }
}
