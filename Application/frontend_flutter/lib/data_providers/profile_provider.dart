import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';

class ProfileProvider with ChangeNotifier {
  GetProfileResponse? _profileData;
  bool _isLoading = false;
  String? _errorMessage;

  GetProfileResponse? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfileData() async {
    if (_profileData == null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      try {
        _profileData = await UserApi.getProfileInformation();
        print(_profileData?.firstName);
      } catch (e) {
        _errorMessage = 'Failed to load profile data. Please try again.';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearData() {
    _profileData = null;
    notifyListeners();
  }
}
