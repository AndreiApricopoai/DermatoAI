import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';

class GeneralInputField extends StatelessWidget {
  final String labelText;
  final double labelFontSize;
  final double padding;
  final double iconSize;
  final double borderThickness;
  final Color borderColorDisabled;
  final Color colorTheme;
  final IconData icon;
  final Color iconColor;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const GeneralInputField({
    super.key,
    this.labelText = 'Default Text',
    this.labelFontSize = 13,
    this.padding = 10.0,
    this.iconSize = 13.0,
    this.borderThickness = 1.5,
    this.borderColorDisabled = AppMainTheme.black,
    this.colorTheme = AppMainTheme.black,
    this.iconColor = AppMainTheme.black,
    this.onChanged,
    this.validator,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.left,
      cursorColor: colorTheme,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: labelFontSize,
        ),
        floatingLabelStyle: TextStyle(
          color: colorTheme,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppMainTheme.black,
            width: borderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme,
            width: borderThickness,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppMainTheme.black,
            width: borderThickness,
          ),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      controller: controller,
    );
  }
}
