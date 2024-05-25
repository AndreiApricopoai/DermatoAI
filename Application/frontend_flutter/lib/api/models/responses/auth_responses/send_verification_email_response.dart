import 'package:frontend_flutter/api/models/responses/base_response.dart';

class SendVerificationEmailResponse extends BaseApiResponse {
  final String? dataMessage;

  SendVerificationEmailResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        super.fromJson();
}
