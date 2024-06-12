import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/login_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/reset_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_forgot_password_email_request.dart';
import 'package:frontend_flutter/app/local_storage.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';

class ForgotPasswordActions {
  final BuildContext context;
  final TextEditingController emailController;
  final TextEditingController tokenController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Function(bool) setLoadingState;
  final Function(bool) setEmailSentState;

  ForgotPasswordActions({
    required this.context,
    required this.emailController,
    required this.tokenController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.setLoadingState,
    required this.setEmailSentState,
  });

  void dispose() {
    emailController.dispose();
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> sendForgotPasswordEmail() async {
    if (formKey.currentState?.validate() == true) {
      setLoadingState(true);

      String email = emailController.text;
      var sendForgotPasswordEmailRequest =
          SendForgotPasswordEmailRequest(email: email);

      try {
        var response = await AuthApi.sendForgotPasswordEmail(
            sendForgotPasswordEmailRequest);

        if (context.mounted) {
          if (response.isSuccess) {
            setLoadingState(false);
            setEmailSentState(true);
            SnackbarManager.showSuccessSnackBar(context,
                'An email containing the verification token was sent!');
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

  Future<void> resetPassword() async {
    if (formKey.currentState?.validate() == true) {
      setLoadingState(true);

      String email = emailController.text;
      String forgotPasswordToken = tokenController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      var resetPasswordRequest = ResetPasswordRequest(
          password: password,
          confirmPassword: confirmPassword,
          forgotPasswordToken: forgotPasswordToken);

      try {
        var response = await AuthApi.resetPassword(resetPasswordRequest);

        if (response.isSuccess) {
          var loginRequest = LoginRequest(email: email, password: password);
          var loginResponse = await AuthApi.login(loginRequest, false);

          if (context.mounted) {
            if (loginResponse.isSuccess) {
              final extractedInitialProfile =
                  await UserApi.setInitialProfileInformation();

              if (extractedInitialProfile) {
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (Route<dynamic> route) => false,
                    arguments: {
                      'actions': [SnackBarActions.successfulResetPassword],
                    },
                  );
                }
              } else {
                SessionManager.clearSession();
                await LocalStorage.clearRefreshToken();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                    arguments: {
                      'actions': [SnackBarActions.failedToFetchProfile],
                    },
                  );
                }
              }

              return;
            } else {
              if (loginResponse.apiResponseCode == 3) {
                SnackbarManager.showWarningSnackBar(
                    context, loginResponse.getValidationErrorsFormatted());
              } else {
                SnackbarManager.showErrorSnackBar(
                    context, loginResponse.gerErrorMessage());
              }
            }
          }
          setLoadingState(false);
          setEmailSentState(true);
        } else {
          if (context.mounted) {
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
