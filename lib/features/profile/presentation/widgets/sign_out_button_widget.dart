import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';

/// Widget que muestra el botón de cerrar sesión.
///
/// Presenta un botón que permite al usuario cerrar sesión en la aplicación,
/// con un diseño destacado en color rojo para indicar una acción importante.
class SignOutButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const SignOutButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        icon: const Icon(ProfileUI.signOutIcon),
        label: const Text(ProfileStrings.signOutButton),
        onPressed: onPressed,
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
} 