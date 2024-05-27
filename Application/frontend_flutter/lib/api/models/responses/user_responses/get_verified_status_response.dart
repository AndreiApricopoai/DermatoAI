import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetVerifiedStatusResponse extends BaseApiResponse {
  final bool? verified;

  GetVerifiedStatusResponse.fromJson(super.json)
      : verified = json['data']?['verified'],
        super.fromJson();
}
