import 'package:frontend_flutter/api/models/responses/base_response.dart';

class RegisterResponse extends BaseApiResponse {
  final String? dataMessage;
  final bool? sentVerificationEmail;
  final String? token;
  final String? refreshToken;

  RegisterResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        sentVerificationEmail = json['data']?['sentVerification'],
        token = json['data']?['token'],
        refreshToken = json['data']?['refreshToken'],
        super.fromJson();
}
