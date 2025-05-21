import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/auth_bloc_handler.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/confirm_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            horizontal:
                isSmallScreen
                    ? ProfileUI.contentPadding / 2
                    : ProfileUI.contentPadding,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de perfil del usuario (avatar e información)
              UserProfileSectionWidget(
                onEditPressed: _onEditProfilePressed,
                onAvatarTap: () {
                  // Permitir visualización o edición de avatar al hacer tap
                },
              ),

              const SizedBox(height: ProfileUI.sectionSpacing),

              // Sección de menú de opciones
              ProfileMenuSectionWidget(
                onMenuItemTap: (route) => _navigateTo(context, route),
              ),

              // const SizedBox(height: ProfileUI.sectionSpacing * 1.8),

              // Botón de cerrar sesión
              SignOutButtonWidget(
                onPressed: () => _showSignOutConfirmation(context),
              ),

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
      barrierColor: Colors.black.withOpacity(0.5),
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
