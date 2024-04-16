import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';

class PasswordInputField extends StatefulWidget {
  final String labelText;
  final double labelFontSize;
  final double padding;
  final double iconSize;
  final double borderThickness;
  final Color borderColorDisabled;
  final Color colorTheme;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const PasswordInputField({
    super.key,
    this.labelText = 'Password',
    this.labelFontSize = 13,
    this.padding = 10.0,
    this.iconSize = 13.0,
    this.borderThickness = 1.5,
    this.borderColorDisabled = AppMainTheme.black,
    this.colorTheme = AppMainTheme.black,
    this.onChanged,
    this.controller,
    this.validator,
  });

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured,
      textAlign: TextAlign.left,
      cursorColor: widget.colorTheme,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.padding,
          horizontal: widget.padding,
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: widget.labelFontSize,
        ),
        floatingLabelStyle: TextStyle(
          color: widget.colorTheme,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(Icons.lock, size: widget.iconSize),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            size: 18,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppMainTheme.black,
            width: widget.borderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.colorTheme,
            width: widget.borderThickness,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppMainTheme.black,
            width: widget.borderThickness,
          ),
        ),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
