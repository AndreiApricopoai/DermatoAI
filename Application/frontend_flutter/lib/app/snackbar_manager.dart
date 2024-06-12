import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SnackbarManager {
  static void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.white,
    int durationInSeconds = 3,
    double? fontSize,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger == null) return;

    scaffoldMessenger.clearSnackBars();
    final snackBar = SnackBar(
      content: Text(message,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          )),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          scaffoldMessenger.hideCurrentSnackBar();
        },
      ),
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    TextStyle? contentTextStyle,
  }) {
    _showSnackBar(context, message,
        backgroundColor: Colors.green, durationInSeconds: 5, fontSize: 14);
  }

  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    TextStyle? contentTextStyle,
  }) {
    _showSnackBar(context, message,
        backgroundColor: Colors.orange, durationInSeconds: 5, fontSize: 12);
  }

  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    TextStyle? contentTextStyle,
  }) {
    _showSnackBar(context, message,
        backgroundColor: Colors.red, durationInSeconds: 5, fontSize: 14);
  }

  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.white,
    int durationInSeconds = 3,
    double fontSize = 14,
  }) {
    _showSnackBar(context, message,
        backgroundColor: backgroundColor,
        durationInSeconds: durationInSeconds,
        fontSize: fontSize);
  }

  static void performSnackBarAction(int actionCode, BuildContext context) {
    if (!context.mounted) {
      return;
    }

    switch (actionCode) {
      case SnackBarActions.successfulRegistrationEmailSending:
        _scheduleSnackBar(() {
          SnackbarManager.showSuccessSnackBar(context,
              "Registered successfully, an email was sent to verify your account. Please check your email.");
        }, context);
        SnackbarManager.showSuccessSnackBar(context,
            "Registered successfully, an email was sent to verify your account. Please check your email.");
        break;
      case SnackBarActions.successfulResetPassword:
        _scheduleSnackBar(() {
          SnackbarManager.showSuccessSnackBar(
              context, "Password reset successfully.");
        }, context);
        break;
      case SnackBarActions.failedRegistrationEmailSending:
        _scheduleSnackBar(() {
          SnackbarManager.showErrorSnackBar(context,
              "Failed to send verification email. Please try again from profile page.");
        }, context);
        break;
      case SnackBarActions.failedToFetchProfile:
        _scheduleSnackBar(() {
          SnackbarManager.showErrorSnackBar(
              context, "Failed to fetch profile information. Please try again later to connect to your account.");
        }, context);
        break;
      default:
        break;
    }
  }

  static void _scheduleSnackBar(VoidCallback callback, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        callback();
      }
    });
  }
}

class SnackBarActions {
  static const int successfulRegistrationEmailSending = 1;
  static const int failedRegistrationEmailSending = 2;
  static const int successfulResetPassword = 3;
  static const int failedToFetchProfile = 4;
}
