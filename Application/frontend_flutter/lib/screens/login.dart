import 'dart:convert';
import 'package:frontend_flutter/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:frontend_flutter/api/models/requests/login_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:frontend_flutter/widgets/button_text.dart';
import 'package:frontend_flutter/widgets/divider_options.dart';
import 'package:frontend_flutter/widgets/input_general_field.dart';
import 'package:frontend_flutter/widgets/input_password.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/extensions/exception_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_title.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  StreamSubscription? _sub;
  bool _rememberMe = false;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _sub?.cancel();
    super.dispose();
  }


    Future<void> _initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'yourapp' && uri.host == 'callback') {
        _handleCallback(uri);
      }
    }, onError: (err) {
      // Handle error
    });
  }

    Future<void> _loginWithGoogle() async {
    const url = '${ApiConstants.baseUrlGoogle}auth/google/login';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleCallback(Uri uri) {
    final responseStr = uri.queryParameters['response'];
    if (responseStr != null) {
      final response = json.decode(responseStr);
      if (response['isSuccess'] == true) {
        // Handle successful login
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Handle login failure
        SnackbarManager.showErrorSnackBar(context, 'Google login failed: ${response['errorMessage']}');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google login failed: Unknown error')));
    }
    setState(() {
      _isLoading = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  ),
                  const SizedBox(height: 30),
                  PasswordInputField(
                    labelText: 'Password',
                    labelFontSize: 14,
                    padding: 10.0,
                    iconSize: 15.0,
                    colorTheme: AppMainTheme.blueLevelFive,
                    onChanged: (value) {},
                    validator: InputValidators.passwordValidator,
                    controller: _passwordController,
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
                        onPressed: _isLoading ? () {} : () {},
                        text: 'Forgot Password?',
                        fontSize: 13,
                        color: AppMainTheme.blueLevelFour,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.roboto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  CustomElevatedButton(
                    onPressed: _isLoading
                        ? () {}
                        : () {
                            _handleLogin(context);
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
                    borderWidth: 2.0,
                    icon: const AssetImage("assets/icons/google_logo.png"),
                    iconSize: 20,
                    text: 'Login with Google',
                    fontFamily: GoogleFonts.roboto,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    onPressed: _isLoading
                        ? () {}
                        : () {
                            _loginWithGoogle();
                          },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppMainTheme.infoGray,
                        ),
                      ),
                      CustomTextButton(
                        text: 'Sign up',
                        fontSize: 14,
                        color: AppMainTheme.blueLevelFour,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.roboto,
                        onPressed: _isLoading
                            ? () {}
                            : () {
                                Navigator.pushNamed(context, '/register');
                              },
                      ),
                    ],
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

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      var loginRequest = LoginRequest(email: email, password: password);
      try {
        var response = await AuthApi.login(loginRequest, _rememberMe);
        if (context.mounted) {
          if (response.isSuccess) {
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
