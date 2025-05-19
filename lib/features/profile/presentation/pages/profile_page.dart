import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/auth_bloc_handler.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/confirm_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showSignOutConfirmation(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: AuthBlocHandler.handleAuthState,
      builder: (context, state) {
        final isLoading = AuthBlocHandler.isLoading(state);
        return Scaffold(
          appBar: const CustomAppBar(
            titleText: ProfileStrings.profileTitle,
            showBack: false, // O true si se puede volver desde aquí
          ),
          body: LoadingOverlay(
            isLoading: isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: ProfileUI.sectionSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de Información Personal (Ejemplo)
                    _buildSectionTitle(ProfileStrings.personalInformation),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.editProfileIcon,
                      title: ProfileStrings.editProfile,
                      onTap: () => AppLogger.logInfo('Navegar a Editar Perfil'),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.myOrdersIcon,
                      title: ProfileStrings.myOrders,
                      onTap: () => AppLogger.logInfo('Navegar a Mis Pedidos'),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.myFavoritesIcon,
                      title: ProfileStrings.myFavorites,
                      onTap: () => AppLogger.logInfo('Navegar a Mis Favoritos'),
                    ),
                    const SizedBox(height: ProfileUI.sectionSpacing),

                    // Sección de Configuración (Ejemplo)
                    _buildSectionTitle(ProfileStrings.settings),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.shippingAddressesIcon,
                      title: ProfileStrings.shippingAddresses,
                      onTap:
                          () => AppLogger.logInfo(
                            'Navegar a Direcciones de Envío',
                          ),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.paymentMethodsIcon,
                      title: ProfileStrings.paymentMethods,
                      onTap:
                          () => AppLogger.logInfo('Navegar a Métodos de Pago'),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.appNotificationsIcon,
                      title: ProfileStrings.appNotifications,
                      onTap:
                          () => AppLogger.logInfo('Navegar a Notificaciones'),
                    ),
                    const SizedBox(height: ProfileUI.sectionSpacing),

                    // Sección de Ayuda (Ejemplo)
                    _buildSectionTitle(ProfileStrings.helpCenter),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.privacyPolicyIcon,
                      title: ProfileStrings.privacyPolicy,
                      onTap:
                          () => AppLogger.logInfo(
                            'Navegar a Política de Privacidad',
                          ),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.termsConditionsIcon,
                      title: ProfileStrings.termsConditions,
                      onTap:
                          () => AppLogger.logInfo(
                            'Navegar a Términos y Condiciones',
                          ),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.faqIcon,
                      title: ProfileStrings.faq,
                      onTap: () => AppLogger.logInfo('Navegar a FAQ'),
                    ),
                    ProfileMenuItemWidget(
                      icon: ProfileUI.contactSupportIcon,
                      title: ProfileStrings.contactSupport,
                      onTap:
                          () =>
                              AppLogger.logInfo('Navegar a Contactar Soporte'),
                    ),
                    const SizedBox(height: ProfileUI.sectionSpacing),

                    // Botón de Cerrar Sesión
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ProfileUI.contentPadding,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            ProfileUI.signOutIcon,
                            color: Colors.white,
                          ),
                          label: const Text(
                            ProfileStrings.signOutButton,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _showSignOutConfirmation(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .error, // Color rojo para cerrar sesión
                            padding: const EdgeInsets.symmetric(
                              vertical: ProfileUI.itemSpacing * 0.8,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: ProfileUI.sectionSpacing),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: ProfileUI.contentPadding,
        right: ProfileUI.contentPadding,
        bottom: ProfileUI.itemSpacing / 2,
      ),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
      ),
    );
  }
}
