import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/option_item_widget.dart';

/// Modelo de datos para una opción individual en [OptionSelectorWidget].
class OptionData {
  /// El texto a mostrar para la opción.
  final String text;

  /// El color asociado con la opción (usado para selectores de color).
  final Color? colorValue;

  OptionData({required this.text, this.colorValue});
}

/// Un widget que muestra una lista de opciones seleccionables (ej. para color o talla)
/// en un modal o sección con un título y un botón de cierre.
class OptionSelectorWidget extends StatelessWidget {
  /// El título del selector (ej. "Color", "Talla").
  final String title;

  /// La lista de [OptionData] a mostrar.
  final List<OptionData> options;

  /// El índice de la opción actualmente seleccionada.
  final int selectedIndex;

  /// Callback que se invoca cuando una nueva opción es seleccionada.
  /// Devuelve el índice de la opción seleccionada.
  final ValueChanged<int> onOptionSelected;

  /// Callback que se invoca cuando se presiona el botón de cierre.
  final VoidCallback onClose;

  const OptionSelectorWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppDimens.screenPadding / 2,
      ), // Un padding general
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            AppDimens.optionItemBorderRadius,
          ), // Usar el mismo radio que los items
          topRight: Radius.circular(AppDimens.optionItemBorderRadius),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(255),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila de Título y Botón de Cierre
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimens.vSpace16,
              left: AppDimens.screenPadding / 2,
              right: AppDimens.screenPadding / 2,
            ),
            // Usaremos un Stack para centrar el título y posicionar el botón de cierre a la derecha.
            child: Stack(
              alignment:
                  Alignment
                      .center, // Esto ayuda a centrar el hijo no posicionado (el título)
              children: [
                // Título Centrado
                Center(
                  child: Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                ),
                // Botón de Cierre Alineado a la Derecha
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textDark),
                    onPressed: onClose,
                    iconSize: AppDimens.iconSize,
                    // Añadir padding al IconButton si es necesario para que no esté pegado al borde
                    // padding: EdgeInsets.zero, // por defecto es 8.0
                    // constraints: BoxConstraints(), // para quitar el tamaño mínimo si se desea
                  ),
                ),
              ],
            ),
          ),
          // Lista de Opciones
          ListView.separated(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Si está dentro de otro scrollable
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.vSpace8,
                  horizontal: AppDimens.screenPadding / 2,
                ),
                child: OptionItemWidget(
                  text: option.text,
                  itemColor: option.colorValue,
                  isSelected: index == selectedIndex,
                  onTap: () => onOptionSelected(index),
                ),
              );
            },
            separatorBuilder:
                (context, index) => const SizedBox(height: AppDimens.vSpace8),
          ),
          const SizedBox(height: AppDimens.vSpace16), // Espacio al final
        ],
      ),
    );
  }
}
