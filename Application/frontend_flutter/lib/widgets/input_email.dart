import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';

class EmailInputField extends StatelessWidget {
  final String labelText;
  final double labelFontSize;
  final double padding;
  final double iconSize;
  final Color colorTheme;
  final ValueChanged<String>? onChanged;

  const EmailInputField({
    super.key,
    this.labelText = 'Email',
    this.labelFontSize = 14,
    this.padding = 10.0,
    this.iconSize = 15.0,
    this.colorTheme = AppMainTheme.black,
    this.onChanged,
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
            Icons.email,
            size: iconSize,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme,
            width: 2.0,
          ),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
