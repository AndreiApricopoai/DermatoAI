import 'dart:convert';

class SendForgotPasswordEmailRequest {
  final String email;

  SendForgotPasswordEmailRequest({
    required this.email,
  });

  String toJson() {
    return json.encode({
      'email': email,
    });
  }
}
