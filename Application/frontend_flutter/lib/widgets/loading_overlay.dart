import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }
    return const Stack(
      children: [
        Opacity(
          opacity: 0.4,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 7.0,
            color: AppMainTheme.blueLevelFive,
          ),
        ),
      ],
    );
  }
}
