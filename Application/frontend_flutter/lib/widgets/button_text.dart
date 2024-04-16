import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatelessWidget {

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Function fontFamily;
  final Color color;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    this.text = 'Default Text',
    this.fontSize = 17,
    this.color = AppMainTheme.black,
    this.fontWeight = FontWeight.w300,
    this.fontFamily = GoogleFonts.roboto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: fontFamily(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}