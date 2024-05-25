import 'package:frontend_flutter/api/models/responses/base_response.dart';

class ChangePasswordResponse extends BaseApiResponse {
  final String? dataMessage;

  ChangePasswordResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        super.fromJson();
}
