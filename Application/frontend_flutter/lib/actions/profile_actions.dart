import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/change_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_verification_email_request.dart';
import 'package:frontend_flutter/api/models/requests/feedback_requests/create_feedback_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/logout_request.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/api/api_calls/feedback_api.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/api_calls/user_api.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/custom_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileActions {
  static Future<void> launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(context, 'Could not launch the page');
        }
      }
    } on Exception {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(context, 'Could not launch the page');
      }
    }
  }

  static Future<bool> sendFeedback(
      BuildContext context,
      String category,
      String content,
      Function(bool) setLoading,
      Function(bool, String) showSnackbar) async {
    setLoading(true);
    try {
      final request =
          CreateFeedbackRequest(category: category, content: content);
      final response = await FeedbackApi.sendFeedback(request);
      setLoading(false);
      showSnackbar(
          response.isSuccess,
          response.isSuccess
              ? 'Feedback sent successfully'
              : 'Failed to send feedback');
      return response.isSuccess;
    } catch (e) {
      setLoading(false);
      showSnackbar(false, 'Failed to send feedback');
      return false;
    }
  }

  static void showFeedbackDialog(
      BuildContext context, Function(bool) setLoading) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController contentController = TextEditingController();
    String category = 'app';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomAlertDialog(
          title: 'Send Feedback',
          content: Form(
            key: formKey,
            child: Column(
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
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: AppMainTheme.blueLevelFive,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.blueLevelFive,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.black,
                        width: 1.0,
                      ),
                    ),
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: AppMainTheme.blueLevelFive,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.blueLevelFive,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.black,
                        width: 1.0,
                      ),
                    ),
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    return InputValidators.feedbackContentValidator(
                        value?.trim() ?? '');
                  },
                ),
              ],
            ),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Send',
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              Navigator.of(dialogContext).pop();
              await sendFeedback(
                  context, category, contentController.text.trim(), setLoading,
                  (isSuccess, message) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (isSuccess) {
                    SnackbarManager.showSuccessSnackBar(context, message);
                  } else {
                    SnackbarManager.showErrorSnackBar(context, message);
                  }
                });
              });
            }
          },
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
          SnackbarManager.showErrorSnackBar(context, 'Failed to verify email status.');
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
        SnackbarManager.showErrorSnackBar(context, 'An error occurred while sending verification email');
      }
    } finally {
      setLoading(false);
    }
  }

  static Future<void> logout(
      BuildContext context, Function(bool) setLoading) async {
    final refreshToken = SessionManager.getRefreshToken();
    if (refreshToken == null && context.mounted) {
      SnackbarManager.showErrorSnackBar(context, 'You are already logged out');
      return;
    }

    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Confirm Logout',
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 15),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Logout',
          onCancel: () => Navigator.of(context).pop(false),
          onConfirm: () => Navigator.of(context).pop(true),
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
          SnackbarManager.showErrorSnackBar(context, 'Failed to log out');
        }
      } finally {
        setLoading(false);
      }
    }
  }

  static Future<void> changePassword(
      BuildContext context,
      String currentPassword,
      String newPassword,
      Function(bool) setLoading,
      Function(bool, String) showSnackbar) async {
    setLoading(true);
    try {
      final request = ChangePasswordRequest(
        oldPassword: currentPassword,
        password: newPassword,
        confirmPassword: newPassword,
      );
      final response = await AuthApi.changePassword(request);
      setLoading(false);
      showSnackbar(
          response.isSuccess,
          response.isSuccess
              ? 'Password changed successfully'
              : 'Failed to change password');
    } catch (e) {
      setLoading(false);
      showSnackbar(false, 'Failed to change password');
    }
  }

  static void showChangePasswordDialog(
      BuildContext context, Function(bool) setLoading) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomAlertDialog(
          title: 'Change Password',
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: AppMainTheme.blueLevelFive,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.blueLevelFive,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.black,
                        width: 1.0,
                      ),
                    ),
                    labelText: 'Current Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    return InputValidators.passwordValidator(
                        value?.trim() ?? '');
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: AppMainTheme.blueLevelFive,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.blueLevelFive,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.black,
                        width: 1.0,
                      ),
                    ),
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    return InputValidators.passwordValidator(
                        value?.trim() ?? '');
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: AppMainTheme.blueLevelFive,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.blueLevelFive,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppMainTheme.black,
                        width: 1.0,
                      ),
                    ),
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    return InputValidators.confirmPasswordValidator(
                        value?.trim() ?? '', newPasswordController.text.trim());
                  },
                ),
              ],
            ),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Change',
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              Navigator.of(dialogContext).pop();
              await changePassword(
                  context,
                  currentPasswordController.text.trim(),
                  newPasswordController.text.trim(),
                  setLoading, (isSuccess, message) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (isSuccess) {
                    SnackbarManager.showSuccessSnackBar(context, message);
                  } else {
                    SnackbarManager.showErrorSnackBar(context, message);
                  }
                });
              });
            }
          },
        );
      },
    );
  }
}
