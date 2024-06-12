import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import '../actions/forgot_password_actions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

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
  late ForgotPasswordActions _forgotPasswordActions;

  String _instructionText =
      'Please enter your email address to receive a verification token. You will be guided in the next steps to reset your password.';

  @override
  void initState() {
    super.initState();
    _forgotPasswordActions = ForgotPasswordActions(
      context: context,
      emailController: _emailController,
      tokenController: _tokenController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      formKey: _formKey,
      setLoadingState: _setLoadingState,
      setEmailSentState: _setEmailSentState,
    );
  }

  @override
  void dispose() {
    _forgotPasswordActions.dispose();
    super.dispose();
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setEmailSentState(bool emailSent) {
    setState(() {
      _emailSent = emailSent;
      _instructionText =
          'Paste the verification token you received in your email along with your new password to reset your current password';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppMainTheme.blueLevelFive, size: 25),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Forgot Password',
              style: GoogleFonts.roboto(
                color: AppMainTheme.blueLevelFive,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    _instructionText,
                    style: GoogleFonts.roboto(
                      color: AppMainTheme.infoGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
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
                            ? () =>
                                _forgotPasswordActions.sendForgotPasswordEmail()
                            : () => _forgotPasswordActions.resetPassword(),
                    text: !_emailSent
                        ? 'Send Verification Email'
                        : 'Reset Password',
                    buttonColor: AppMainTheme.blueLevelFour,
                    textColor: AppMainTheme.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.roboto,
                    width: 180,
                    height: 45,
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
