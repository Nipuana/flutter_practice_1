import 'package:flutter/material.dart';

class Nav {
  Nav._();

  // PUSH OPERATIONS

  /// Push a new screen onto the stack.
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
  /// Replace the current screen with a new screen (e.g., Splash -> Home).
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget screen, {
    TO? result,
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => screen),
      result: result,
    );
  }

  /// Clear all previous screens and make this screen the root (e.g., Logout).
  static Future<T?> pushAndRemoveAll<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }




  // POP OPERATIONS
  /// Pop the top-most screen off the stack (with optional return data).
  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop<T>(result);
    }
  }

  /// Pop screens until reaching the first/root screen.
  static void popToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}