import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/app_colors.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_ecommerce/core/constants/app_strings.dart';
import 'package:flutter_application_ecommerce/core/constants/app_text_styles.dart';

/// Widget que muestra un ítem de menú en la pantalla de perfil.
///
/// Presenta un diseño consistente con un icono a la izquierda, título
/// y flecha a la derecha. Incluye efectos visuales para estados activos e inactivos.
class ProfileMenuItemWidget extends StatelessWidget {
  /// Icono mostrado al lado izquierdo del ítem
  final IconData icon;

  /// Título del ítem de menú
  final String title;

  /// Callback ejecutado al presionar el ítem
  final VoidCallback onTap;

  /// Color personalizado para el icono principal
  final Color? iconColor;

  /// Indica si se debe mostrar el icono de flecha a la derecha
  final bool showTrailingIcon;

  /// Indicador de estado activo/seleccionado para el ítem
  final bool isActive;

  /// Crea un ítem de menú para la pantalla de perfil.
  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.showTrailingIcon = true,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Optimizamos acceso a Theme para facilitar adaptación a modo oscuro
    final theme = Theme.of(context);
    final primaryColor = AppColors.primary;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.inputFill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias, // Para el efecto de splash
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(ProfileUI.menuItemHeight),
          child: Row(
            children: [
              // Icono principal con posible indicador de selección
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isActive ? primaryColor : (iconColor ?? primaryColor),
                  size: ProfileUI.menuItemIconSize,
                ),
              ),
              const SizedBox(width: 16),

              // Texto principal expandible para ocupar espacio disponible
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subheading.copyWith(
                    fontWeight:
                        FontWeight.w500, // Peso medio para mejor legibilidad
                    fontSize:
                        15, // Tamaño ligeramente reducido para mejor jerarquía
                    color: isActive ? primaryColor : AppColors.textDark,
                    letterSpacing:
                        0.1, // Ligero tracking para mejor legibilidad
                  ),
                ),
              ),

              // Flecha o indicador de navegación a la derecha
              if (showTrailingIcon)
                SvgPicture.asset(
                  AppStrings.arrowRightIcon,
                  width: ProfileUI.menuItemTrailingIconSize,
                  height: ProfileUI.menuItemTrailingIconSize,
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? primaryColor
                        : AppColors.textDark.withOpacity(0.7),
                    BlendMode.srcIn,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
