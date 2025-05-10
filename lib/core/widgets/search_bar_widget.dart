import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

/// Un widget de barra de búsqueda reutilizable.
///
/// Puede funcionar como un campo de texto para búsqueda activa o como un botón
/// que navega a una pantalla de búsqueda dedicada.
class SearchBarWidget extends StatelessWidget {
  /// Controlador opcional si se usa como un [TextField] activo.
  final TextEditingController? controller;

  /// Callback opcional que se activa cuando el texto cambia (si es un [TextField]).
  final ValueChanged<String>? onChanged;

  /// Callback opcional para cuando se presiona la barra (si actúa como botón).
  /// Si se provee, el widget muestra un [Text] placeholder en lugar de un [TextField].
  final VoidCallback? onTap;

  /// Crea una instancia de [SearchBarWidget].
  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap, // Si onTap es null, el GestureDetector no interfiere con el TextField
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.contentPaddingHorizontal,
          vertical:
              AppDimens
                  .genderSelectorPadding, // Reutiliza padding para consistencia de altura
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(
            AppDimens.buttonRadius,
          ), // Bordes muy redondeados
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppStrings.searchIcon,
              width: AppDimens.iconSize,
              height: AppDimens.iconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppDimens.iconLabelGap),
            Expanded(
              // Si onTap está definido, se comporta como un botón mostrando un hint.
              // De lo contrario, es un campo de texto funcional.
              child:
                  onTap != null
                      ? Text(
                        AppStrings.homeSearchHint,
                        style: AppTextStyles.inputHint,
                      )
                      : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: AppStrings.homeSearchHint,
                          hintStyle: AppTextStyles.inputHint,
                          border:
                              InputBorder
                                  .none, // Sin borde interno del TextField
                          isDense: true, // Reduce la altura interna
                          contentPadding:
                              EdgeInsets
                                  .zero, // Sin padding interno del TextField
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
