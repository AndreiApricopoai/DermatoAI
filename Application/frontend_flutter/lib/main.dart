import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/screens/forgot_password.dart';
import 'package:frontend_flutter/screens/home.dart';
import 'package:frontend_flutter/screens/login.dart';
import 'package:frontend_flutter/screens/register.dart';
import 'package:frontend_flutter/screens/splash.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DermatoAI',
      theme: ThemeData(
        primaryColor: AppMainTheme.blueLevelFive,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) =>  HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
