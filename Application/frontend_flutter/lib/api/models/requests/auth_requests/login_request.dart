import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  String toJson() {
    return json.encode({
      'email': email,
      'password': password,
    });
  }
}
