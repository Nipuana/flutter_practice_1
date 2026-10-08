import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFFE60023);
  static const text = Color(0xFF1F1F1F);
  static const textSecondary = Color(0xFF555555);
  static const textMuted = Color(0xFF777777);
  static const surface = Colors.white;
  static const surfaceMuted = Color(0xFFF0F0F0);
  static const border = Color(0xFFEEEEEE);
  static const inactive = Color(0xFFD8D8D8);
  static const onboardingPink = Color(0xFFFFE4E8);
  static const onboardingTeal = Color(0xFFE2F2F1);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 36.0;

  static const screen = EdgeInsets.all(xl);
  static const screenBottom = EdgeInsets.fromLTRB(xl, sm, xl, xxxl);
  static const button = EdgeInsets.symmetric(vertical: md);
  static const buttonWithHorizontal = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );
}

abstract final class AppRadii {
  static const button = 28.0;
  static const card = 28.0;
  static const pill = 20.0;
  static const indicator = 8.0;
}
