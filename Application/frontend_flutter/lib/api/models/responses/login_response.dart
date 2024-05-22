import 'package:frontend_flutter/api/models/responses/base_response.dart';

class LoginResponse extends BaseApiResponse {
  final String? dataMessage;
  final String? token;
  final String? refreshToken;

  LoginResponse({
    required super.isSuccess,
    required super.apiResponseCode,
    super.data,
    super.message,
    super.error,
    this.dataMessage,
    this.token,
    this.refreshToken,
  });

  LoginResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        token = json['data']?['token'],
        refreshToken = json['data']?['refreshToken'],
        super.fromJson();
}
