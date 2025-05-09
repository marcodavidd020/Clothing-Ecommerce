import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

/// Un botón utilizado para mostrar y potencialmente cambiar la selección de género (ej. "Hombres", "Mujeres").
///
/// Muestra el género actualmente seleccionado y un icono de flecha hacia abajo.
class GenderSelectorButton extends StatelessWidget {
  /// El texto del género actualmente seleccionado (ej. "Hombres").
  final String selectedGender;
  
  /// Callback que se ejecuta cuando el botón es presionado.
  final VoidCallback onPressed;

  /// Crea una instancia de [GenderSelectorButton].
  const GenderSelectorButton({
    super.key,
    required this.selectedGender,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.genderSelectorPadding,
          vertical: AppDimens.genderSelectorPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill, // Fondo del botón
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius), // Bordes redondeados
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
          children: [
            Text(
              selectedGender,
              style: AppTextStyles.inputText.copyWith(
                fontWeight: FontWeight.bold, // Texto en negrita
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: AppDimens.genderSelectorPadding), // Espacio entre texto e icono
            SvgPicture.asset(
              AppStrings.arrowDownIcon,
              width: AppDimens.backIconSize, // Reutilizando un tamaño de icono pequeño
              height: AppDimens.backIconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn, // Para aplicar el color al SVG
              ),
            ),
          ],
        ),
      ),
    );
  }
}
