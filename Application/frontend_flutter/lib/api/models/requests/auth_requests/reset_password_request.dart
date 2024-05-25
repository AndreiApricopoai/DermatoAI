import 'dart:convert';

class ResetPasswordRequest {
  final String forgotPasswordToken;
  final String password;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.forgotPasswordToken,
    required this.password,
    required this.confirmPassword,
  });

  String toJson() {
    return json.encode({
      'forgotPasswordToken': forgotPasswordToken,
      'password': password,
      'confirmPassword': confirmPassword,
    });
  }
}
