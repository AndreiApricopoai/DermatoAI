import 'dart:convert';

class SendVerificationEmailRequest {
  final String email;

  SendVerificationEmailRequest({
    required this.email,
  });

  String toJson() {
    return json.encode({
      'email': email,
    });
  }
}
