import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Function fontFamily;
  final double letterSpacing;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    this.text = 'Default Text',
    this.buttonColor = AppMainTheme.black,
    this.textColor = AppMainTheme.white,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w300,
    this.fontFamily = GoogleFonts.roboto,
    this.letterSpacing = 0.0,
    this.width = 230,
    this.height = 50,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 12.0,
          ),
        ),
        child: Text(
          text,
          style: fontFamily(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
          ),
        ),
      ),
    );
  }
}
