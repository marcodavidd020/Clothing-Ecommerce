import 'package:flutter/material.dart';
import '../constants/constants.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    fontFamily: 'Gabarito',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      headlineSmall: AppTextStyles.heading,
      bodyMedium: AppTextStyles.inputHint,
      bodyLarge: AppTextStyles.button,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppDimens.contentPaddingVertical,
        horizontal: AppDimens.contentPaddingHorizontal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius / 12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
