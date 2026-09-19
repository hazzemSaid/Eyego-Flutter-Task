import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.white,
      brightness: Brightness.dark,
      primary: AppColors.white,
      secondary: AppColors.gray400,
      surface: AppColors.gray900,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray900,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md,
          vertical: AppDimens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.gray800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.white, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.gray500),
        hintStyle: const TextStyle(color: AppColors.gray600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
    );
  }

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.black,
      brightness: Brightness.light,
      primary: AppColors.black,
      secondary: AppColors.gray600,
      surface: AppColors.white,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md,
          vertical: AppDimens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.black, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.fieldRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.gray500),
        hintStyle: const TextStyle(color: AppColors.gray400),
      ),
    );
  }
}
