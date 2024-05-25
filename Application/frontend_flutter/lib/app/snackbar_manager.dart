import 'package:flutter/material.dart';

class SnackbarManager {
  static void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.white,
    int durationInSeconds = 3,
    double? fontSize,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
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
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
