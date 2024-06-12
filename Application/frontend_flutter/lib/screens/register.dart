import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/widgets/button_text.dart';
import 'package:frontend_flutter/widgets/divider_options.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import '../actions/register_actions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late RegisterActions _registerActions;

  final String termsUrl = '${ApiConstants.baseUrlStaticFiles}terms';
  final String policyUrl = '${ApiConstants.baseUrlStaticFiles}policy';

  @override
  void initState() {
    super.initState();
    _registerActions = RegisterActions(
      context: context,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      formKey: _formKey,
      setLoadingState: _setLoadingState,
      termsUrl: termsUrl,
      policyUrl: policyUrl,
    );
    _registerActions.initUniLinks();
  }

  @override
  void dispose() {
    _registerActions.dispose();
    super.dispose();
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
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
                    color: Colors.black,
                    height: 1.5,
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
                                _registerActions.launchURL(context, termsUrl);
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
                                _registerActions.launchURL(context, policyUrl);
                              },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CustomElevatedButton(
                onPressed: _isLoading
                    ? () {}
                    : () => _registerActions.handleRegister(),
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
                          _registerActions.registerWithGoogle();
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
}
