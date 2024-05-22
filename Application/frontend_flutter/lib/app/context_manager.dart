import 'package:flutter/material.dart';

class ContextManager {
  static BuildContext? _context;

  static void updateContext(BuildContext context) {
    _context = context;
  }

  static BuildContext? get context => _context;

  static bool isContextMounted() {
    return _context != null && _context!.mounted;
  }
}
