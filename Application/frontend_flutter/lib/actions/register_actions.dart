import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_constants.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/register_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';

class RegisterActions {
  final BuildContext context;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Function(bool) setLoadingState;
  bool isLoading;
  StreamSubscription? _sub;

  final String termsUrl;
  final String policyUrl;

  RegisterActions({
    required this.context,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.setLoadingState,
    this.isLoading = false,
    required this.termsUrl,
    required this.policyUrl,
  });

  void initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'yourapp' && uri.host == 'callback') {
        _handleGoogleCallback(uri);
      }
    }, onError: (err) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context,
            "An error occurred while trying to handle the google register");
      }
    });
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _sub?.cancel();
  }

  Future<void> launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, 'Could not launch url');
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context, e.getMessage);
      }
    }
  }

  Future<void> registerWithGoogle() async {
    const url = '${ApiConstants.baseUrlGoogleAuth}auth/google/register';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch google register url';
    }
  }

  void _handleGoogleCallback(Uri uri) {
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else {
        SnackbarManager.showErrorSnackBar(context, 'Google register failed');
      }
    } else {
      SnackbarManager.showErrorSnackBar(context, 'Google register failed');
    }
    setLoadingState(false);
  }

  void handleRegister() async {
    if (formKey.currentState?.validate() == true) {
      setLoadingState(true);

      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      var registerRequest = RegisterRequest(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword);
      try {
        var response = await AuthApi.register(registerRequest);
        if (context.mounted) {
          if (response.isSuccess) {
            final emailSent = (response.sentVerificationEmail != null &&
                    response.sentVerificationEmail == true)
                ? true
                : false;

            if (emailSent) {
              SnackbarManager.showSuccessSnackBar(context,
                  'Account created successfully. Please check your email to verify your account.');
            } else {
              SnackbarManager.showWarningSnackBar(context,
                  'Account created successfully. An error occurred while sending the verification email. Please try again later.');
            }

            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (Route<dynamic> route) => false,
              arguments: emailSent,
            );
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
