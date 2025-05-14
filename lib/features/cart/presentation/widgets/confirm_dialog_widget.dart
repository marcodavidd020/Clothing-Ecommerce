import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Widget personalizado para diálogos de confirmación.
class ConfirmDialogWidget extends StatelessWidget {
  /// Título del diálogo.
  final String title;

  /// Mensaje de contenido del diálogo.
  final String message;

  /// Texto para el botón de cancelar.
  final String cancelText;

  /// Texto para el botón de confirmar.
  final String confirmText;

  /// Icono que se muestra en el diálogo.
  final IconData icon;

  /// Color del icono y el botón de confirmar.
  final Color accentColor;

  /// Crea un diálogo de confirmación personalizado.
  const ConfirmDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    this.icon = Icons.warning_rounded,
    this.accentColor = AppColors.error,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.productItemBorderRadius),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Cuerpo del diálogo
        Container(
          margin: const EdgeInsets.only(top: CartUI.dialogTopMargin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              AppDimens.productItemBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(
                  (CartUI.shadowOpacity * 255).round(),
                ),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            left: CartUI.dialogContentPadding,
            right: CartUI.dialogContentPadding,
            top: CartUI.dialogContentPadding * 2.5,
            bottom: CartUI.dialogContentPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimens.vSpace16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppDimens.vSpace24),
              Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: CartUI.dialogButtonVerticalPadding,
                        ),
                        backgroundColor: AppColors.inputFill,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.buttonRadius,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        cancelText,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.vSpace16),
                  // Botón Confirmar
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: CartUI.dialogButtonVerticalPadding,
                        ),
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.buttonRadius,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        confirmText,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Icono circular en la parte superior
        CircleAvatar(
          backgroundColor: accentColor,
          radius: CartUI.dialogIconRadius,
          child: Icon(icon, size: CartUI.dialogIconSize, color: Colors.white),
        ),
      ],
    );
  }
}
