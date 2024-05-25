import 'package:frontend_flutter/api/models/responses/base_response.dart';

class SendForgotPasswordEmailResponse extends BaseApiResponse {
  final String? dataMessage;

  SendForgotPasswordEmailResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        super.fromJson();
}
