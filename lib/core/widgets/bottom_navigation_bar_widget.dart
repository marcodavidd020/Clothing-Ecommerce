import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

/// Un widget de barra de navegación inferior personalizado y reutilizable.
///
/// Muestra una serie de iconos y gestiona el estado del ítem actualmente seleccionado.
class BottomNavigationBarWidget extends StatelessWidget {
  /// El índice del ítem actualmente seleccionado en la barra de navegación.
  final int currentIndex;
  
  /// Callback que se invoca cuando se presiona un ítem de la barra de navegación.
  /// Recibe el índice del ítem presionado.
  final ValueChanged<int> onTap;

  /// Crea una instancia de [BottomNavigationBarWidget].
  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // Asegura que todos los items sean visibles y tengan el mismo ancho
      backgroundColor: AppColors.white,   // Fondo de la barra
      elevation: 0,                       // Sin sombra para una apariencia plana
      selectedItemColor: AppColors.primary, // Color para el ícono seleccionado (aunque el color lo gestiona el SvgPicture)
      unselectedItemColor: AppColors.textDark.withOpacity(0.5), // Color para iconos no seleccionados
      showSelectedLabels: false, // No muestra etiquetas de texto para los items
      showUnselectedLabels: false,
      items: [
        // Se construyen los items de navegación.
        // El método _buildNavItem se encarga de la lógica de coloreado del icono.
        _buildNavItem(AppStrings.homeIcon, 0, context),
        _buildNavItem(AppStrings.notificationIcon, 1, context),
        _buildNavItem(AppStrings.receiptIcon, 2, context),
        _buildNavItem(AppStrings.profileIcon, 3, context),
      ],
    );
  }

  /// Construye un [BottomNavigationBarItem] individual.
  ///
  /// Aplica un [ColorFilter] al [SvgPicture] para cambiar su color
  /// basado en si el ítem es el actualmente seleccionado.
  BottomNavigationBarItem _buildNavItem(String iconPath, int index, BuildContext context) {
    final bool isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: AppDimens.iconSize,
        height: AppDimens.iconSize,
        // Aplica el color primario si está seleccionado, sino un gris opaco.
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.primary : AppColors.textDark.withOpacity(0.5),
          BlendMode.srcIn,
        ),
      ),
      label: '', // Etiqueta vacía ya que se configuran para no mostrarse.
    );
  }
}
