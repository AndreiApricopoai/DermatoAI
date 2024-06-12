import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/app/session_manager.dart';

class GetProfileResponse extends BaseApiResponse {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePhoto;
  final bool? verified;
  final bool? isGoogleUser;

  GetProfileResponse({
    this.firstName,
    this.lastName,
    this.email,
    this.profilePhoto,
    this.isGoogleUser,
    this.verified, required super.isSuccess, required super.apiResponseCode,
  });

  GetProfileResponse.fromJson(super.json)
      : firstName = json['data']?['firstName'],
        lastName = json['data']?['lastName'],
        email = json['data']?['email'],
        profilePhoto = json['data']?['profilePhoto'],
        verified = json['data']?['verified'],
        isGoogleUser = json['data']?['isGoogleUser'],
        super.fromJson();

  static GetProfileResponse fromSession() {
    return GetProfileResponse(
      firstName: SessionManager.getFirstName(),
      lastName: SessionManager.getLastName(),
      email: SessionManager.getEmail(),
      profilePhoto: SessionManager.getProfilePhoto(),
      verified: SessionManager.getVerified(),
      isGoogleUser: SessionManager.getIsGoogleUser(),
      isSuccess: true,
      apiResponseCode: 1
    );
  }
}
