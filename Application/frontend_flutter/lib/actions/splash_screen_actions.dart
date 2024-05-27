import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/get_access_token_request.dart';
import 'package:frontend_flutter/app/local_storage.dart';

class SplashScreenActions {
  final BuildContext context;
  final AnimationController animationController;

  SplashScreenActions({
    required this.context,
    required this.animationController,
  });

  void startSplashScreenTimer() async {
    animationController.forward();
    bool hasValidSession = await _checkAndRefreshToken();

    if (context.mounted) {
      if (hasValidSession) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false); // change this to '/home' if you want to redirect to the home screen
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
  }

  Future<bool> _checkAndRefreshToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      GetAccessTokenRequest getAccessTokenRequest =
          GetAccessTokenRequest(refreshToken: refreshToken);
      final response = await AuthApi.getAccessToken(getAccessTokenRequest);
      if (response.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    animationController.dispose();
  }
}
