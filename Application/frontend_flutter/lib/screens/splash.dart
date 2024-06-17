import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/get_access_token_request.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import '../app/app_main_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _fetchedProfile = false;

  void startSplashScreenTimer() async {
    bool hasValidSession = await _checkAndRefreshToken();
    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      if (hasValidSession) {
        final refreshToken = await LocalStorage.getRefreshToken();
        SessionManager.setRefreshToken(refreshToken!);
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      } else {
        SessionManager.clearSession();
        LocalStorage.clearRefreshToken();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (Route<dynamic> route) => false,
            arguments: {
              'actions': _fetchedProfile
                  ? null
                  : [SnackBarActions.failedToFetchProfile],
            },
          );
        }
      }
    }
  }

  Future<bool> _checkAndRefreshToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      setState(() {
        _fetchedProfile = true;
      });
      return false;
    }
    try {
      GetAccessTokenRequest getAccessTokenRequest =
          GetAccessTokenRequest(refreshToken: refreshToken);
      final response = await AuthApi.getAccessToken(getAccessTokenRequest);
      final extractedInitialProfile =
          await UserApi.setInitialProfileInformation();

      setState(() {
        _fetchedProfile = extractedInitialProfile;
      });

      return (response.isSuccess && extractedInitialProfile);
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 30),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppMainTheme.blueLevelFive,
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
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 250,
                  child: Text(
                    'Early Detection, Healthier Skin.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.0,
                      color: AppMainTheme.white,
                    ),
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
