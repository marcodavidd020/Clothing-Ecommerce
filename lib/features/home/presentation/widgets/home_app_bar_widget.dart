import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';

/// Widget que implementa el AppBar personalizado para la página Home.
///
/// Incluye el selector de género, botón de perfil y botón de carrito con contador.
class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Género actualmente seleccionado (Men/Women)
  final String selectedGender;

  /// Callback cuando se cambia el género
  final Function(String) onGenderChanged;

  /// Callback cuando se presiona el botón de carrito
  final VoidCallback onBagPressed;

  /// Callback cuando se presiona el botón de perfil
  final VoidCallback onProfilePressed;

  /// URL de la imagen de perfil (puede ser un recurso local o remoto)
  final String profileImageUrl;

  /// Constructor principal
  const HomeAppBarWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onBagPressed,
    required this.onProfilePressed,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      showBack: false,
      onBagPressed: onBagPressed,
      profileImageUrl: profileImageUrl,
      onProfilePressed: onProfilePressed,
      title: _buildGenderSelector(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: AppDimens.appBarActionRightPadding,
          ),
          child: CartBadgeWidget(onPressed: onBagPressed),
        ),
      ],
    );
  }

  /// Construye el selector de género utilizando el widget del Core
  Widget _buildGenderSelector() {
    return GenderSelectorButton(
      selectedGender: selectedGender,
      onPressed:
          () => onGenderChanged(selectedGender == "Men" ? "Women" : "Men"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
