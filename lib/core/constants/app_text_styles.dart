import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static const TextStyle inputHint = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  static const TextStyle button = TextStyle(
    fontFamily: 'Circular Std',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.6875,
    letterSpacing: -0.495753,
    color: AppColors.white,
  );
  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.link,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle inputText = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
  );
  static const TextStyle socialButton = TextStyle(
    fontFamily: 'Circular Std',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.6875,
    letterSpacing: -0.495753,
    color: AppColors.textDark,
  );
}
