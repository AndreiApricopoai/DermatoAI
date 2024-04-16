import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';

class PasswordInputField extends StatefulWidget {
  final String labelText;
  final double labelFontSize;
  final double padding;
  final double iconSize;
  final Color colorTheme;
  final ValueChanged<String>? onChanged;

  const PasswordInputField({
    super.key,
    this.labelText = 'Password',
    this.labelFontSize = 14,
    this.padding = 10.0,
    this.iconSize = 15.0,
    this.colorTheme = AppMainTheme.black,
    this.onChanged,
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
            size: 20,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        border:  OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.colorTheme,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.colorTheme,
            width: 2.0,
          ),
        ),
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }
}
