import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart';
import 'package:frontend_flutter/api/api_constants.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/login_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';

class LoginActions {
  final BuildContext context;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final Function(bool) setLoadingState;
  bool rememberMe;
  bool isLoading;
  StreamSubscription? _sub;

  LoginActions({
    required this.context,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.setLoadingState,
    this.rememberMe = false,
    this.isLoading = false,
  });

  void initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'yourapp' && uri.host == 'callback') {
        _handleGoogleCallback(uri);
      }
    }, onError: (err) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context,
            "An error occurred while trying to handle the google login");
      }
    });
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _sub?.cancel();
  }

  Future<void> loginWithGoogle() async {
    const url = '${ApiConstants.baseUrlGoogleAuth}auth/google/login';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context,
            "An error occurred while trying to handle the google login");
      }
    }
  }

  void _handleGoogleCallback(Uri uri) async {
    final responseStr = uri.queryParameters['response'];
    if (responseStr != null) {
      final response = json.decode(responseStr);
      if (response['isSuccess'] == true) {
        final refreshToken = response['data']?['refreshToken'];
        final accesToken = response['data']?['token'];

        if (refreshToken != null && refreshToken.isNotEmpty) {
          SessionManager.setRefreshToken(refreshToken);
        }
        if (accesToken != null && accesToken.isNotEmpty) {
          SessionManager.setAccessToken(accesToken);
        }
        final extractedInitialProfile =
            await UserApi.setInitialProfileInformation();

        if (context.mounted) {
          if (extractedInitialProfile) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          } else {
            SessionManager.clearSession();
            await LocalStorage.clearRefreshToken();
            if (context.mounted) {
              SnackbarManager.showErrorSnackBar(context,
                  'Failed to fetch profile information. Please try again later to connect to your account.');
            }
          }
        }
      } else {
        SnackbarManager.showErrorSnackBar(context, 'Google login failed');
      }
    } else {
      SnackbarManager.showErrorSnackBar(context, 'Google login failed');
    }
    setLoadingState(false);
  }

  void handleLogin() async {
    if (formKey.currentState?.validate() == true) {
      setLoadingState(true);

      String email = emailController.text;
      String password = passwordController.text;

      var loginRequest = LoginRequest(email: email, password: password);
      try {
        var response = await AuthApi.login(loginRequest, rememberMe);
        if (context.mounted) {
          if (response.isSuccess) {
            final extractedInitialProfile =
                await UserApi.setInitialProfileInformation();
            if (extractedInitialProfile) {
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              }
            } else {
              SessionManager.clearSession();
              await LocalStorage.clearRefreshToken();
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(context,
                    'Failed to fetch profile information. Please try again later to connect to your account.');
              }
            }
          } else {
            if (response.apiResponseCode == 3) {
              SnackbarManager.showWarningSnackBar(
                  context, response.getValidationErrorsFormatted());
            } else {
              SnackbarManager.showErrorSnackBar(
                  context, response.gerErrorMessage());
            }
          }
        }
      } on Exception catch (e) {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, e.getMessage);
        }
      } finally {
        if (context.mounted) {
          setLoadingState(false);
        }
      }
    }
  }
}
