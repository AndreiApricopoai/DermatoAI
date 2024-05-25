import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetAccesTokenResponse extends BaseApiResponse {
  final String? dataMessage;
  final String? token;

  GetAccesTokenResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        token = json['data']?['token'],
        super.fromJson();
}
