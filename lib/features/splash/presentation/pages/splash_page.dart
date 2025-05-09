import 'dart:async'; // Necesario para Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/pages/sign_in_page.dart'; // Se navega a MainShellPage
import 'package:flutter_application_ecommerce/features/shell/presentation/presentation.dart'; // Para MainShellPage

/// Página de Splash (pantalla de carga inicial) de la aplicación.
///
/// Muestra un logo y un indicador durante un tiempo determinado y luego
/// navega a la pantalla principal de la aplicación ([MainShellPage]).
class SplashPage extends StatefulWidget {
  /// Crea una instancia de [SplashPage].
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  /// Navega a la [MainShellPage] después de una demora de 3 segundos.
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Comprueba si el widget todavía está en el árbol de widgets
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // Obtiene el tamaño de la pantalla
    return Scaffold(
      body: Container(
        width: size.width, // Ocupa todo el ancho
        height: size.height, // Ocupa todo el alto
        decoration: BoxDecoration(
          color: AppColors.primary, // Color de fondo primario
        ),
        child: Center(
          child: Image.asset(
            AppStrings.logo, // Ruta al logo desde constantes
            width: AppDimens.logoWidth, // Ancho fijo para el logo
            height: AppDimens.logoHeight, // Alto fijo para el logo
          ),
        ),
      ),
    );
  }
}
