import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/profile_menu_item_widget.dart';

/// Widget que muestra la sección de menú en la pantalla de perfil.
///
/// Construye una lista de opciones de menú para configuración y navegación.
class ProfileMenuSectionWidget extends StatelessWidget {
  final String? activeOption;
  final Function(String) onMenuItemTap;

  const ProfileMenuSectionWidget({
    super.key,
    this.activeOption,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de sección
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              ProfileStrings.settings,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Opciones de menú
          _buildMenuItem(
            icon: Icons.receipt_long,
            title: 'Mis Órdenes',
            onTap: () => onMenuItemTap('orders'),
            isActive: activeOption == 'orders',
          ),
          _buildMenuItem(
            icon: Icons.local_offer,
            title: 'Mis Cupones',
            onTap: () => onMenuItemTap('coupons'),
            isActive: activeOption == 'coupons',
          ),
          _buildMenuItem(
            icon: ProfileUI.shippingAddressesIcon,
            title: ProfileStrings.address,
            onTap: () => onMenuItemTap('address'),
            isActive: activeOption == 'address',
          ),
          _buildMenuItem(
            icon: ProfileUI.myFavoritesIcon,
            title: ProfileStrings.wishlist,
            onTap: () => onMenuItemTap('wishlist'),
            isActive: activeOption == 'wishlist',
          ),
          _buildMenuItem(
            icon: ProfileUI.paymentMethodsIcon,
            title: ProfileStrings.payment,
            onTap: () => onMenuItemTap('payment'),
            isActive: activeOption == 'payment',
          ),
          _buildMenuItem(
            icon: ProfileUI.faqIcon,
            title: ProfileStrings.help,
            onTap: () => onMenuItemTap('help'),
            isActive: activeOption == 'help',
          ),
          _buildMenuItem(
            icon: ProfileUI.contactSupportIcon,
            title: ProfileStrings.support,
            onTap: () => onMenuItemTap('support'),
            isActive: activeOption == 'support',
          ),
        ],
      ),
    );
  }

  /// Helper para crear un ítem de menú.
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return ProfileMenuItemWidget(
      icon: icon,
      title: title,
      onTap: onTap,
      isActive: isActive,
    );
  }
}
