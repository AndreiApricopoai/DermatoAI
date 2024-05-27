import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetProfileResponse extends BaseApiResponse {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePhoto;
  final bool? verified;

  GetProfileResponse.fromJson(super.json)
      : firstName = json['data']?['firstName'],
        lastName = json['data']?['lastName'],
        email = json['data']?['email'],
        profilePhoto = json['data']?['profilePhoto'],
        verified = json['data']?['verified'],
        super.fromJson();
}
