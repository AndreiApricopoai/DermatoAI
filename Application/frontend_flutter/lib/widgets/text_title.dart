import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTitle extends StatelessWidget {

  final String text;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;
  final Color color;
  final Function fontFamily;

  const TextTitle({
    super.key,
    this.text = "Default Text",
    this.fontSize = 25,
    this.color = AppMainTheme.black,
    this.fontWeight = FontWeight.w300,
    this.fontFamily = GoogleFonts.roboto,
    this.letterSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: fontFamily(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}