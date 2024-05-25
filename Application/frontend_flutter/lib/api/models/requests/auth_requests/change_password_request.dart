import 'dart:convert';

class ChangePasswordRequest {
  final String oldPassword;
  final String password;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.password,
    required this.confirmPassword,
  });

  String toJson() {
    return json.encode({
      'oldPassword': oldPassword,
      'password': password,
      'confirmPassword': confirmPassword,
    });
  }
}
