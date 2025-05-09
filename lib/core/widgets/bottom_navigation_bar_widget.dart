import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

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
      type:
          BottomNavigationBarType
              .fixed, // Para que todos los items sean visibles
      backgroundColor:
          AppColors.white, // O el color que prefieras para el fondo
      elevation: 0, // Asegura que no haya sombra/elevación
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textDark.withOpacity(0.5),
      showSelectedLabels: false, // Ocultar etiquetas si solo quieres iconos
      showUnselectedLabels: false,
      items: [
        _buildNavItem(AppStrings.homeIcon, 0),
        _buildNavItem(AppStrings.notificationIcon, 1),
        _buildNavItem(AppStrings.receiptIcon, 2),
        _buildNavItem(AppStrings.profileIcon, 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: AppDimens.iconSize,
        height: AppDimens.iconSize,
        colorFilter: ColorFilter.mode(
          currentIndex == index
              ? AppColors.primary
              : AppColors.textDark.withOpacity(0.5),
          BlendMode.srcIn,
        ),
      ),
      label: '', // Etiqueta vacía ya que las ocultamos
    );
  }
}
