import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Un widget que representa un solo ítem en un selector de opciones (ej. color o talla).
///
/// Muestra el nombre de la opción, un círculo de color (si se provee), y un
/// ícono de verificación si está seleccionado.
class OptionItemWidget extends StatelessWidget {
  /// El texto que describe la opción (ej. "Naranja", "XL").
  final String text;

  /// El color a mostrar en un círculo junto al texto.
  /// Si es nulo, no se muestra ningún círculo de color.
  final Color? itemColor;

  /// Indica si este ítem está actualmente seleccionado.
  final bool isSelected;

  /// Callback que se ejecuta cuando el ítem es presionado.
  final VoidCallback onTap;

  /// Crea una instancia de [OptionItemWidget].
  const OptionItemWidget({
    super.key,
    required this.text,
    this.itemColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isSelected ? AppColors.primary : AppColors.optionUnselectedBackground;
    final Color textColor = isSelected ? AppColors.white : AppColors.textDark;
    final TextStyle textStyle =
        isSelected
            ? AppTextStyles.button.copyWith(color: textColor)
            : AppTextStyles.inputText.copyWith(
              color: textColor,
            ); // Usar inputText para no seleccionado

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppDimens.optionItemPadding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.optionItemBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: textStyle),
            Row(
              spacing: AppDimens.vSpace8,
              children: [
                if (itemColor != null)
                  Container(
                    width: AppDimens.optionColorCircleSize,
                    height: AppDimens.optionColorCircleSize,
                    decoration: BoxDecoration(
                      color: itemColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.white
                                : AppColors
                                    .optionBorder, // Borde blanco si seleccionado sobre fondo oscuro
                        width: 1.5,
                      ),
                    ),
                  ),
                if (itemColor != null && isSelected)
                  const SizedBox(
                    width: AppDimens.optionTextIconSpacing / 2,
                  ), // Espacio menor antes del check
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppColors.white,
                    size:
                        AppDimens.iconSize,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
