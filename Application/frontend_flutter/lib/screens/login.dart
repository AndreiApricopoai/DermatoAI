import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/widgets/button_text.dart';
import 'package:frontend_flutter/widgets/divider_options.dart';
import 'package:frontend_flutter/widgets/input_email.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _rememberMe = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/icons/app_logo_blue2.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              const TextTitle(
                text: 'Welcome Back',
                color: AppMainTheme.blueLevelFour,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 40),
              EmailInputField(
                  labelText: 'Email',
                  colorTheme: AppMainTheme.blueLevelFive,
                  onChanged: (value) {
                    // do something
                  }),
              const SizedBox(height: 30),
              PasswordInputField(
                labelText: 'Password',
                colorTheme: AppMainTheme.blueLevelFive,
                onChanged: (value) {
                  // do something
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        activeColor: AppMainTheme.blueLevelFour,
                        value: _rememberMe,
                        onChanged: (newValue) {
                          setState(() {
                            _rememberMe = newValue!;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  CustomTextButton(
                      onPressed: () {},
                      text: 'Forgot Password?',
                      fontSize: 13,
                      color: AppMainTheme.blueLevelFour,
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.roboto),
                ],
              ),
              const SizedBox(height: 25),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {}
                },
                text: 'Login',
                buttonColor: AppMainTheme.blueLevelFour,
                textColor: AppMainTheme.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.roboto,
                width: 230,
                height: 50,
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
                  borderColor: AppMainTheme.black,
                  pressColor: AppMainTheme.black,
                  borderWidth: 1.5,
                  icon: const AssetImage("assets/icons/google_logo.png"),
                  iconSize: 20,
                  text: 'Login with Google',
                  fontFamily: GoogleFonts.roboto,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    // do something
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  CustomTextButton(
                    text: 'Sign up',
                    fontSize: 14,
                    color: AppMainTheme.blueLevelFour,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.roboto,
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
