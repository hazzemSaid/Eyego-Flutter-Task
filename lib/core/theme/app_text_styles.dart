import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String? fontFamily = null;

  static TextStyle display({Color? color}) => TextStyle(
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: color ?? AppColors.white,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: color ?? AppColors.white,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: color ?? AppColors.white,
      );

  static TextStyle body({Color? color}) => TextStyle(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.gray400,
      );

  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontSize: 13.5,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.gray500,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: color ?? AppColors.gray500,
      );

  static TextStyle button({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color ?? AppColors.black,
      );

  static const TextStyle logoMark = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: AppColors.white,
  );
}
