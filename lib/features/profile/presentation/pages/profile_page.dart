import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/auth_bloc_handler.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/confirm_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/di/service_locator.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';
import 'package:flutter_application_ecommerce/core/widgets/network_image_with_placeholder.dart';
import 'package:flutter_application_ecommerce/core/constants/app_strings.dart';

/// Pantalla principal de Perfil (Settings) del usuario.
///
/// Muestra la información del usuario (avatar, nombre, email, teléfono)
/// y opciones de configuración para la cuenta.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: AuthBlocHandler.handleAuthState,
      builder: (context, state) {
        final isLoading = AuthBlocHandler.isLoading(state);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            titleText: ProfileStrings.settings,
            showBack: false,
          ),
          body: _buildBody(context, isLoading),
        );
      },
    );
  }

  /// Construye el cuerpo principal de la pantalla con overlay de carga.
  Widget _buildBody(BuildContext context, bool isLoading) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return LoadingOverlay(
      isLoading: isLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: ProfileUI.sectionSpacing / 2,
            // Padding adaptativo según el tamaño de pantalla
            horizontal:
                isSmallScreen
                    ? ProfileUI.contentPadding / 2
                    : ProfileUI.contentPadding,
          ),
          physics: const BouncingScrollPhysics(), // Efecto de rebote más suave
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserProfileSection(context),
              const SizedBox(height: ProfileUI.sectionSpacing),
              _buildMenuOptions(context),
              const SizedBox(height: ProfileUI.sectionSpacing * 1.8),
              _buildSignOutButton(context),
              SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom +
                    ProfileUI.sectionSpacing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la sección de perfil del usuario con avatar y datos.
  Widget _buildUserProfileSection(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: ServiceLocator.sl<AuthStorage>().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostrar estado de carga
          return const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        return Column(
          children: [_buildUserAvatar(user), _buildUserInfoCard(user)],
        );
      },
    );
  }

  /// Construye el avatar del usuario.
  Widget _buildUserAvatar(UserModel? user) {
    final String? avatarUrl = user?.avatar;
    final bool hasValidAvatar =
        avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        (avatarUrl.startsWith('http') || avatarUrl.startsWith('https'));

    return Hero(
      tag: 'user-avatar',
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 18),
        child: Center(
          child: Material(
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.3),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:
                        hasValidAvatar
                            ? NetworkImageWithPlaceholder(
                              imageUrl: avatarUrl!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              shape: BoxShape.circle,
                            )
                            : Image.asset(
                              AppStrings.userPlaceholderIcon,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                  ),
                  // Añadir un efecto sutil de brillo
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: AppColors.primary.withOpacity(0.1),
                        onTap: () {
                          // Permitir visualización o edición de avatar al hacer tap
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el contenedor con la información del usuario.
  Widget _buildUserInfoCard(UserModel? user) {
    final String name = user?.fullName ?? ProfileStrings.defaultUserName;
    final String email = user?.email ?? '';
    final String phone = user?.phoneNumber ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(ProfileUI.contentPadding),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.subheading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 18, // Ligeramente más grande para destacar
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          email,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textDark.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (phone.isNotEmpty)
                      Text(
                        phone,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textDark.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _onEditProfilePressed,
                  splashColor: AppColors.primary.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ProfileStrings.editButton,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye los ítems de menú para la configuración.
  Widget _buildMenuOptions(BuildContext context) {
    // Determinar qué opción podría estar activa basada en alguna lógica de navegación
    String? activeOption;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de sección opcional
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

          _buildMenuItem(
            icon: ProfileUI.shippingAddressesIcon,
            title: ProfileStrings.address,
            onTap: () => _navigateTo(context, 'address'),
            isActive: activeOption == 'address',
          ),
          _buildMenuItem(
            icon: ProfileUI.myFavoritesIcon,
            title: ProfileStrings.wishlist,
            onTap: () => _navigateTo(context, 'wishlist'),
            isActive: activeOption == 'wishlist',
          ),
          _buildMenuItem(
            icon: ProfileUI.paymentMethodsIcon,
            title: ProfileStrings.payment,
            onTap: () => _navigateTo(context, 'payment'),
            isActive: activeOption == 'payment',
          ),
          _buildMenuItem(
            icon: ProfileUI.faqIcon,
            title: ProfileStrings.help,
            onTap: () => _navigateTo(context, 'help'),
            isActive: activeOption == 'help',
          ),
          _buildMenuItem(
            icon: ProfileUI.contactSupportIcon,
            title: ProfileStrings.support,
            onTap: () => _navigateTo(context, 'support'),
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

  /// Construye el botón de cerrar sesión.
  Widget _buildSignOutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        icon: const Icon(ProfileUI.signOutIcon),
        label: const Text(ProfileStrings.signOutButton),
        onPressed: () => _showSignOutConfirmation(context),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFA3636),
          textStyle: const TextStyle(
            fontFamily: 'Gabarito',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: -0.295753,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: ProfileUI.itemSpacing * 0.8,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Método para manejar la navegación a diferentes pantallas.
  void _navigateTo(BuildContext context, String route) {
    // TODO: Implementar navegación a las rutas específicas
  }

  /// Método para manejar el clic en el botón de editar perfil.
  void _onEditProfilePressed() {
    // TODO: Implementar navegación a la pantalla de edición de perfil
  }

  /// Muestra diálogo de confirmación para cerrar sesión.
  void _showSignOutConfirmation(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(
        0.5,
      ), // Barrera más oscura para mejor contraste
      builder: (BuildContext dialogContext) {
        return ConfirmDialogWidget(
          title: ProfileStrings.signOutConfirmationTitle,
          message: ProfileStrings.signOutConfirmationMessage,
          confirmText: ProfileStrings.confirmSignOutButton,
          cancelText: ProfileStrings.cancelButton,
          icon: ProfileUI.signOutIcon,
          accentColor: AppColors.error,
        );
      },
    );

    if (confirmed == true && context.mounted) {
      AuthBlocHandler.signOut(context);
    }
  }
}
