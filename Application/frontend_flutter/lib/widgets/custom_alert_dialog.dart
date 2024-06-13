import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/button_rounded.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: const EdgeInsets.only(top: 25, left: 20, bottom: 15),
      title: Text(title,
          style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: AppMainTheme.blueLevelFive)),
      content: content,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelButtonText,
            style: const TextStyle(
              color: AppMainTheme.alertDialogClose,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        CustomElevatedButton(
          onPressed: onConfirm,
          text: confirmButtonText,
          buttonColor: AppMainTheme.blueLevelFour,
          textColor: AppMainTheme.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.roboto,
          paddingHeight: 2.0,
          paddingWidth: 2.0,
          width: 95,
          height: 40,
        ),
      ],
    );
  }
}
