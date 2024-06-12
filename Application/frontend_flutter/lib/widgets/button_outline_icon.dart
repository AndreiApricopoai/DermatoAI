import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final Color pressColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Function fontFamily;
  final double letterSpacing;
  final double width;
  final double height;
  final double iconSize;
  final Color iconColor;
  final double elementsSpacing;
  final VoidCallback onPressed;
  final ImageProvider icon;

  const CustomOutlinedButton({
    super.key,
    this.text = 'Default Text',
    this.borderColor = AppMainTheme.black,
    this.borderWidth = 1.0,
    this.textColor = AppMainTheme.black,
    this.pressColor = AppMainTheme.black,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w300,
    this.fontFamily = GoogleFonts.roboto,
    this.letterSpacing = 0.0,
    this.width = 230,
    this.height = 50,
    this.iconSize = 20,
    this.iconColor = AppMainTheme.black,
    this.elementsSpacing = 15,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: pressColor,
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: fontFamily(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
                ),
            ),
            SizedBox(width: elementsSpacing),
            ImageIcon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
