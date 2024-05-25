import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_main_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1, milliseconds: 30));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    Timer(const Duration(seconds: 2, microseconds: 30), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppMainTheme.blueLevelFive, // Adjust the color as needed
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/app_logo_white.png',
                  width: 180,
                  height: 180,
                ), // Make sure to use the correct path to your logo
                const SizedBox(height: 50), // Adjust the space as needed
                SizedBox(
                  width: 250, // Adjust the width as needed
                  child: Text(
                    'Early Detection, Healthier Skin.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 30, // Adjust the font size as needed
                      fontWeight:
                          FontWeight.w300, // Adjust the font weight as needed
                      letterSpacing: 1.0, // Adjust the letter spacing as needed
                      color: AppMainTheme.white, // Adjust the color as needed
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
