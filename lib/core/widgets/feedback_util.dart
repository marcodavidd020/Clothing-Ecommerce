import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Utilidad para mostrar feedback visual al usuario
class FeedbackUtil {
  /// Muestra un SnackBar con un mensaje
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(milliseconds: 800),
    Color backgroundColor = AppColors.primary,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: behavior,
      ),
    );
  }
  
  /// Muestra un mensaje de actualización
  static void showUpdatingMessage(BuildContext context, {String? customMessage}) {
    showSnackBar(
      context: context,
      message: customMessage ?? 'Actualizando...',
      duration: const Duration(milliseconds: 800),
      backgroundColor: AppColors.primary,
    );
  }
  
  /// Muestra un mensaje de error
  static void showErrorMessage(BuildContext context, String message) {
    showSnackBar(
      context: context,
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red[700]!,
    );
  }
  
  /// Muestra un mensaje de éxito
  static void showSuccessMessage(BuildContext context, String message) {
    showSnackBar(
      context: context,
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green[700]!,
    );
  }
} 