import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import '../actions/forgot_password_actions.dart';

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
  late ForgotPasswordActions _forgotPasswordActions;

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
    });
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
                            ? () => _forgotPasswordActions.sendForgotPasswordEmail()
                            : () => _forgotPasswordActions.resetPassword(),
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
