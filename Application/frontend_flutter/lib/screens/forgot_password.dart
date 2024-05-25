import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/login_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/reset_password_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_forgot_password_email_request.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_title.dart';
import '../widgets/loading_overlay.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendForgotPasswordEmail() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      String email = _emailController.text;
      var sendForgotPasswordEmailRequest =
          SendForgotPasswordEmailRequest(email: email);
      try {
        var response = await AuthApi.sendForgotPasswordEmail(
            sendForgotPasswordEmailRequest);

        if (context.mounted) {
          if (response.isSuccess) {
            setState(() {
              _isLoading = false;
              _emailSent = true;
            });
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
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String forgotPasswordToken = _tokenController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      var resetPasswordRequest = ResetPasswordRequest(
          password: password,
          confirmPassword: confirmPassword,
          forgotPasswordToken: forgotPasswordToken);

      try {
        var response = await AuthApi.resetPassword(resetPasswordRequest);

        if (context.mounted) {
          if (response.isSuccess) {
            var loginRequest = LoginRequest(email: email, password: password);
            var loginResponse = await AuthApi.login(loginRequest, false);

            if (loginResponse.isSuccess) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              if (loginResponse.apiResponseCode == 3) {
                SnackbarManager.showWarningSnackBar(
                    context, loginResponse.getValidationErrorsFormatted());
              } else {
                SnackbarManager.showErrorSnackBar(
                    context, loginResponse.gerErrorMessage());
              }
            }

            setState(() {
              _isLoading = false;
              _emailSent = true;
            });
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
          setState(() {
            _isLoading = false;
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const TextTitle(
                    text: 'Forgot Password',
                    color: AppMainTheme.blueLevelFour,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 40),
                  if (!_emailSent)
                    GeneralInputField(
                      labelText: 'Email',
                      icon: Icons.email,
                      labelFontSize: 14,
                      padding: 10.0,
                      iconSize: 15.0,
                      colorTheme: AppMainTheme.blueLevelFive,
                      onChanged: (value) {},
                      validator: InputValidators.emailValidator,
                      controller: _emailController,
                    )
                  else ...[
                    GeneralInputField(
                      labelText: 'Verification Token',
                      icon: Icons.vpn_key,
                      labelFontSize: 14,
                      padding: 10.0,
                      iconSize: 15.0,
                      colorTheme: AppMainTheme.blueLevelFive,
                      onChanged: (value) {},
                      validator: InputValidators.verificationTokenValidator,
                      controller: _tokenController,
                    ),
                    const SizedBox(height: 20),
                    PasswordInputField(
                      labelText: 'New Password',
                      labelFontSize: 14,
                      padding: 10.0,
                      iconSize: 15.0,
                      colorTheme: AppMainTheme.blueLevelFive,
                      onChanged: (value) {},
                      validator: InputValidators.passwordValidator,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    PasswordInputField(
                      labelText: 'Confirm Password',
                      labelFontSize: 14,
                      padding: 10.0,
                      iconSize: 15.0,
                      colorTheme: AppMainTheme.blueLevelFive,
                      onChanged: (value) {},
                      validator: (value) =>
                          InputValidators.confirmPasswordValidator(
                              value, _passwordController.text),
                      controller: _confirmPasswordController,
                    ),
                  ],
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    onPressed: _isLoading
                        ? () {}
                        : !_emailSent
                            ? () => _sendForgotPasswordEmail()
                            : () => _resetPassword(),
                    text: !_emailSent
                        ? 'Send Verification Email'
                        : 'Reset Password',
                    buttonColor: AppMainTheme.blueLevelFour,
                    textColor: AppMainTheme.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.roboto,
                    width: 230,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingOverlay(isLoading: _isLoading),
      ],
    );
  }
}
