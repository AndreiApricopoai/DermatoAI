import 'package:frontend_flutter/api/models/responses/base_response.dart';

class LogoutResponse extends BaseApiResponse {
  final String? dataMessage;

  LogoutResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        super.fromJson();
}
