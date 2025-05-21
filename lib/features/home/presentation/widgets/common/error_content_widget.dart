import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Widget que muestra un mensaje de error con botón de reintento.
class ErrorContentWidget extends StatelessWidget {
  /// Mensaje de error a mostrar
  final String message;

  /// Función a ejecutar cuando se presiona el botón de reintento
  final VoidCallback onRetry;

  /// Icono para mostrar (opcional)
  final IconData icon;

  /// Color del icono (opcional)
  final Color? iconColor;

  /// Constructor principal
  const ErrorContentWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? Colors.red[300];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: effectiveIconColor),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 24),
          _buildRetryButton(),
        ],
      ),
    );
  }

  /// Construye el botón de reintento
  Widget _buildRetryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: AppColors.primary.withOpacity(0.3),
        highlightColor: AppColors.textLight.withOpacity(0.1),
        onTap: onRetry,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              'Reintentar',
              style: AppTextStyles.seeAll.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
