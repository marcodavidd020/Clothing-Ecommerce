import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/app_colors.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showTrailingIcon;

  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.showTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            iconColor ??
            AppColors.textDark, // Color por defecto si no se especifica
        size: ProfileUI.menuItemIconSize,
      ),
      title: Text(title),
      trailing:
          showTrailingIcon
              ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              )
              : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ProfileUI.contentPadding,
      ),
      minLeadingWidth: 0, // Para reducir el espacio a la izquierda del icono
    );
  }
}
