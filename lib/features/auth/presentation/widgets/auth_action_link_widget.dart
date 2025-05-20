import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/auth/core/constants/auth_strings.dart';

/// Widget que muestra un enlace de acción para la autenticación.
///
/// Se utiliza para mostrar enlaces como "Crear cuenta" o "Resetear contraseña".
class AuthActionLinkWidget extends StatelessWidget {
  final String mainText;
  final String linkText;
  final VoidCallback onLinkTap;

  const AuthActionLinkWidget({
    super.key,
    required this.mainText,
    required this.linkText,
    required this.onLinkTap,
  });

  /// Construye un enlace para crear una cuenta nueva
  factory AuthActionLinkWidget.createAccount({required VoidCallback onTap}) {
    return AuthActionLinkWidget(
      mainText: AuthStrings.dontHaveAccountText,
      linkText: AuthStrings.createAccountButton,
      onLinkTap: onTap,
    );
  }

  /// Construye un enlace para resetear la contraseña
  factory AuthActionLinkWidget.resetPassword({required VoidCallback onTap}) {
    return AuthActionLinkWidget(
      mainText: AuthStrings.forgotPasswordButton,
      linkText: AuthStrings.resetButton,
      onLinkTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: mainText,
        style: TextStyle(color: AppColors.textDark),
        children: [
          TextSpan(
            text: linkText,
            style: AppTextStyles.link,
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}
