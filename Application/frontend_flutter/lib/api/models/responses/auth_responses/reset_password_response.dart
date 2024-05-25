import 'package:frontend_flutter/api/models/responses/base_response.dart';

class ResetPasswordResponse extends BaseApiResponse {
  final String? dataMessage;

  ResetPasswordResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        super.fromJson();
}
