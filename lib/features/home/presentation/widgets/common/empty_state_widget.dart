import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Widget que muestra un mensaje de estado vacío con un ícono y texto personalizable.
///
/// Útil para mostrar cuando no hay contenido disponible en una sección.
class EmptyStateWidget extends StatelessWidget {
  /// Mensaje a mostrar
  final String message;

  /// Ícono para mostrar (opcional)
  final IconData icon;

  /// Tamaño del ícono (opcional)
  final double iconSize;

  /// Color del ícono (opcional)
  final Color? iconColor;

  /// Constructor
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.category_outlined,
    this.iconSize = 64,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor =
        iconColor ?? AppColors.textLight.withOpacity(0.5);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: effectiveIconColor),
            const SizedBox(height: AppDimens.vSpace16),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
