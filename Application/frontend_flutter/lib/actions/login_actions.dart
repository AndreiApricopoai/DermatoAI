// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:frontend_flutter/api/api_calls/auth_api.dart';
// import 'package:frontend_flutter/app/snackbar_manager.dart';
// import 'package:frontend_flutter/utils/app_main_theme.dart';
// import 'package:frontend_flutter/models/login_request.dart';
// import 'dart:convert';

// class LoginActions {
//   static Future<void> handleLogin(
//       BuildContext context,
//       GlobalKey<FormState> formKey,
//       TextEditingController emailController,
//       TextEditingController passwordController,
//       bool rememberMe) async {
//     if (formKey.currentState?.validate() == true) {
//       String email = emailController.text;
//       String password = passwordController.text;

//       var loginRequest = LoginRequest(email: email, password: password);
//       try {
//         var response = await AuthApi.login(loginRequest, rememberMe);
//         if (context.mounted) {
//           if (response.isSuccess) {
//             Navigator.of(context).pushReplacementNamed('/home');
//           } else {
//             if (response.apiResponseCode == 3) {
//               SnackbarManager.showWarningSnackBar(
//                   context, response.getValidationErrorsFormatted());
//             } else {
//               SnackbarManager.showErrorSnackBar(
//                   context, response.gerErrorMessage());
//             }
//           }
//         }
//       } on Exception catch (e) {
//         if (context.mounted) {
//           SnackbarManager.showErrorSnackBar(context, e.getMessage());
//         }
//       }
//     }
//   }

//   static Future<void> loginWithGoogle(BuildContext context) async {
//     const url = 'https://<your-ngrok-id>.ngrok-free.app/api/auth/google/login';
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   static void handleCallback(BuildContext context, Uri uri) {
//     final responseStr = uri.queryParameters['response'];
//     if (responseStr != null) {
//       final response = json.decode(responseStr);
//       if (response['isSuccess'] == true) {
//         Navigator.of(context).pushReplacementNamed('/home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Google login failed: ${response['message']}')));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Google login failed: Unknown error')));
//     }
//   }
// }
