import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/change_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_verification_email_request.dart';
import 'package:frontend_flutter/api/models/requests/feedback_requests/create_feedback_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/logout_request.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/api/api_calls/feedback_api.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart'; // Import the UserApi
import 'package:frontend_flutter/validators/input_validators.dart';

class ProfileActions {
      static Future<void> sendFeedback(BuildContext context, String category,
      String content, Function(bool) setLoading) async {
    setLoading(true);
    try {
      final request =
          CreateFeedbackRequest(category: category, content: content);
      final response = await FeedbackApi.sendFeedback(request);
      if (response.isSuccess && context.mounted) {
        SnackbarManager.showSuccessSnackBar(
            context, 'Feedback sent successfully');
      } else if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, 'Failed to send feedback');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context, 'Error: $e');
      }
    } finally {
      setLoading(false);
    }
  }

  static void showFeedbackDialog(
      BuildContext context, Function(bool) setLoading) {
    final TextEditingController contentController = TextEditingController();
    String category = 'app';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category,
                items: [
                  'app',
                  'bugs',
                  'usability',
                  'predictions',
                  'AIchat',
                  'other'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    category = newValue;
                  }
                },
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final content = contentController.text.trim();
                final contentError = InputValidators.feedbackContentValidator(content);

                if (contentError != null) {
                  if (context.mounted) {
                    SnackbarManager.showErrorSnackBar(context, contentError);
                  }
                  return;
                }

                Navigator.of(context).pop();
                await sendFeedback(context, category, content, setLoading);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> checkAndFetchVerifiedStatus(
      BuildContext context, Function(bool) setLoading) async {
    if (SessionManager.getVerified() == false) {
      setLoading(true);
      try {
        final response = await UserApi.getVerifiedStatus();
        if (response.isSuccess) {
          SessionManager.setVerified(response.verified!);
          if (response.verified! && context.mounted) {
            SnackbarManager.showSuccessSnackBar(
                context, 'Your email has been verified.');
          }
        } else if (context.mounted) {
          SnackbarManager.showErrorSnackBar(
              context, 'Failed to verify email status.');
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, 'Error: $e');
        }
      } finally {
        setLoading(false);
      }
    }
  }

  static Future<void> sendVerificationEmail(
      BuildContext context, String email, Function(bool) setLoading) async {
    setLoading(true);
    try {
      final request = SendVerificationEmailRequest(email: email);
      final response = await AuthApi.sendVerificationEmail(request);
      if (response.isSuccess && context.mounted) {
        SnackbarManager.showSuccessSnackBar(
            context, 'Verification email sent successfully');
      } else if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, 'Failed to send verification email');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context, 'Error: $e');
      }
    } finally {
      setLoading(false);
    }
  }


  static Future<void> logout(
      BuildContext context, Function(bool) setLoading) async {
    final refreshToken = SessionManager.getRefreshToken();
    if (refreshToken == null && context.mounted) {
      SnackbarManager.showErrorSnackBar(context, 'No refresh token found');
      return;
    }

    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      setLoading(true);
      try {
        final request = LogoutRequest(refreshToken: refreshToken!);
        final response = await AuthApi.logout(request);
        if (response.isSuccess) {
          SessionManager.clearSession();
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          }
        } else if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, 'Failed to log out');
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, 'Error: $e');
        }
      } finally {
        setLoading(false);
      }
    }
  }

  static Future<void> changePassword(BuildContext context,
      String currentPassword, String newPassword, Function(bool) setLoading) async {
    setLoading(true);
    try {
      final request = ChangePasswordRequest(
        oldPassword: currentPassword,
        password: newPassword,
        confirmPassword: newPassword,
      );
      final response = await AuthApi.changePassword(request);
      if (response.isSuccess && context.mounted) {
        SnackbarManager.showSuccessSnackBar(
            context, 'Password changed successfully');
      } else if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, 'Failed to change password');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context, 'Error: $e');
      }
    } finally {
      setLoading(false);
    }
  }

  static void showChangePasswordDialog(BuildContext context,
      Function(bool) setLoading) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController =
        TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                final passwordError =
                    InputValidators.passwordValidator(newPassword);
                final confirmPasswordError =
                    InputValidators.confirmPasswordValidator(
                        confirmPassword, newPassword);

                if (passwordError != null || confirmPasswordError != null) {
                  if (context.mounted) {
                    SnackbarManager.showErrorSnackBar(
                        context, 'Please check your input.');
                  }
                  return;
                }

                Navigator.of(context).pop();
                await changePassword(
                    context, currentPassword, newPassword, setLoading);
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
