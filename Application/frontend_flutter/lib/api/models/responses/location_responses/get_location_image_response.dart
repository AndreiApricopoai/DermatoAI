import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetLocationImageResponse extends BaseApiResponse {
  final String? image;

  GetLocationImageResponse.fromJson(super.json)
      : image = json['data']?['image'],
        super.fromJson();
}
