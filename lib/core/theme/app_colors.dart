import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray950 = Color(0xFF0A0A0A);
  static const Color gray900 = Color(0xFF171717);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gold = Color(0xFFFFD700);

  static const Color error = Color(0xFFDC2626);
  static const Color transparent = Color(0x00000000);

  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gray950, black],
  );
}
