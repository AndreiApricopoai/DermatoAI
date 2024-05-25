import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/register_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/widgets/button_text.dart';
import 'package:frontend_flutter/widgets/divider_options.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          surfaceTintColor: AppMainTheme.blueLevelFive,
          shadowColor: AppMainTheme.blueLevelFive,
          backgroundColor: AppMainTheme.blueLevelFive,
          iconTheme: const IconThemeData(
            color: AppMainTheme.white,
          ),
          title: const TextTitle(
            text: 'Let\'s Get Started',
            fontSize: 25,
            fontFamily: GoogleFonts.roboto,
            fontWeight: FontWeight.w500,
            color: AppMainTheme.white,
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 50),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              GeneralInputField(
                labelText: 'First Name',
                colorTheme: AppMainTheme.blueLevelFive,
                controller: _firstNameController,
                icon: Icons.person,
                validator: InputValidators.nameValidator,
              ),
              const SizedBox(height: 20),
              GeneralInputField(
                labelText: 'Last Name',
                colorTheme: AppMainTheme.blueLevelFive,
                controller: _lastNameController,
                icon: Icons.person_outline,
                validator: InputValidators.nameValidator,
              ),
              const SizedBox(height: 20),
              GeneralInputField(
                labelText: 'Email',
                colorTheme: AppMainTheme.blueLevelFive,
                controller: _emailController,
                icon: Icons.email,
                validator: InputValidators.emailValidator,
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                labelText: 'Password',
                colorTheme: AppMainTheme.blueLevelFive,
                controller: _passwordController,
                validator: InputValidators.passwordValidator,
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                labelText: 'Confirm Password',
                colorTheme: AppMainTheme.blueLevelFive,
                controller: _confirmPasswordController,
                validator: (value) => InputValidators.confirmPasswordValidator(
                    value, _passwordController.text),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black, // Default text color
                    height: 1.5, // Adjust the line spacing
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'By continuing you agree to ',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: const TextStyle(
                          fontSize: 14, color: AppMainTheme.blueLevelFive),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _isLoading
                            ? () {}
                            : () {
                                // Define what you want to do when the terms and conditions is tapped
                              },
                    ),
                    const TextSpan(
                        text: '  and  ',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                          fontSize: 14, color: AppMainTheme.blueLevelFive),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _isLoading
                            ? () {}
                            : () {
                                // Define what you want to do when the privacy policy is tapped
                              },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CustomElevatedButton(
                onPressed: _isLoading ? () {} : () => _handleRegister(context),
                text: 'Create Account',
                buttonColor: AppMainTheme.blueLevelFour,
                textColor: AppMainTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.roboto,
                width: 230,
                height: 45,
              ),
              const SizedBox(height: 20),
              const OptionsDivider(
                color: AppMainTheme.black,
                thickness: 1,
                width: 230,
              ),
              const SizedBox(height: 20),
              CustomOutlinedButton(
                  width: 230,
                  height: 40,
                  borderColor: AppMainTheme.googleButtonOrange,
                  pressColor: AppMainTheme.googleButtonOrange,
                  textColor: AppMainTheme.googleButtonOrange,
                  borderWidth: 2.0,
                  icon: const AssetImage("assets/icons/google_logo.png"),
                  iconSize: 20,
                  iconColor: AppMainTheme.googleButtonOrange,
                  text: 'Sign up with Google',
                  fontFamily: GoogleFonts.roboto,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  onPressed: _isLoading
                      ? () {}
                      : () {
                          // Handle Google Sign Up
                        }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppMainTheme.infoGray,
                    ),
                  ),
                  CustomTextButton(
                    text: 'Login now',
                    fontSize: 14,
                    color: AppMainTheme.blueLevelFour,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.roboto,
                    onPressed: _isLoading
                        ? () {}
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
      LoadingOverlay(isLoading: _isLoading),
    ]);
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

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
                '/home', (Route<dynamic> route) => false);
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
}
