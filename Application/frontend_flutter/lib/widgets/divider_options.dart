import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';

class OptionsDivider extends StatelessWidget {

  final Color color;
  final double thickness;
  final double width;

  const OptionsDivider({
    super.key,
    this.color = AppMainTheme.black,
    this.thickness = 1,
    this.width = 230,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(thickness: thickness),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'OR',
              style: TextStyle(color: color),
            ),
          ),
          Expanded(
            child: Divider(thickness: thickness),
          ),
        ],
      ),
    );
  }
}