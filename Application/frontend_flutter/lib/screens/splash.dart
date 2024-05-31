import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/get_access_token_request.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import '../utils/app_main_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _apiResult = 'Checking...';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
    startSplashScreenTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startSplashScreenTimer() async {
    bool hasValidSession = await _checkAndRefreshToken();
    setState(() {
      _apiResult = hasValidSession ? 'Token is valid' : 'Token is invalid';
    });

    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      if (hasValidSession) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }
  }

  Future<bool> _checkAndRefreshToken() async {
    print("Am intrat in checkAndRefreshToken()");
    final refreshToken = await LocalStorage.getRefreshToken();
    print(refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      GetAccessTokenRequest getAccessTokenRequest =
          GetAccessTokenRequest(refreshToken: refreshToken);
      final response = await AuthApi.getAccessToken(getAccessTokenRequest);
      print(response);
      print(response);print(response);print(response);
      print(SessionManager.getAccessToken());
      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppMainTheme.blueLevelFive, // Adjust the color as needed
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/app_logo_white.png',
                  width: 180,
                  height: 180,
                ), // Make sure to use the correct path to your logo
                const SizedBox(height: 50), // Adjust the space as needed
                SizedBox(
                  width: 250, // Adjust the width as needed
                  child: Text(
                    'Early Detection, Healthier Skin.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 30, // Adjust the font size as needed
                      fontWeight: FontWeight.w300, // Adjust the font weight as needed
                      letterSpacing: 1.0, // Adjust the letter spacing as needed
                      color: AppMainTheme.white, // Adjust the color as needed
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between the text and the result
                Text(
                  _apiResult,
                  style: GoogleFonts.roboto(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.w400, // Adjust the font weight as needed
                    color: AppMainTheme.white, // Adjust the color as needed
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
