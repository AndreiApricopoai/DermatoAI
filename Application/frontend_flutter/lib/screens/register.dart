import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/widgets/button_text.dart';
import 'package:frontend_flutter/widgets/divider_options.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            GeneralInputField(
              labelText: 'Last Name',
              colorTheme: AppMainTheme.blueLevelFive,
              controller: _lastNameController,
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            GeneralInputField(
              labelText: 'Email',
              colorTheme: AppMainTheme.blueLevelFive,
              controller: _emailController,
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            PasswordInputField(
              labelText: 'Password',
              colorTheme: AppMainTheme.blueLevelFive,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            PasswordInputField(
              labelText: 'Confirm Password',
              colorTheme: AppMainTheme.blueLevelFive,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (_passwordController.text != value) {
                  return 'Passwords do not match';
                }
                return null;
              },
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
                      ..onTap = () {
                        // Define what you want to do when terms & conditions is tapped
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
                      ..onTap = () {
                        // Define what you want to do when the privacy policy is tapped
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  // Proceed with login
                }
              },
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
                onPressed: () {
                  // do something
                }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppMainTheme.infoGray,),
                ),
                CustomTextButton(
                  text: 'Login now',
                  fontSize: 14,
                  color: AppMainTheme.blueLevelFour,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.roboto,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
