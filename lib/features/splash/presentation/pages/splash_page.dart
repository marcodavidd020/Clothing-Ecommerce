import 'dart:async'; // Necesario para Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/pages/sign_in_page.dart'; // Se navega a MainShellPage

/// Página de Splash (pantalla de carga inicial) de la aplicación.
///
/// Muestra un logo animado durante un tiempo determinado y luego
/// navega a la pantalla de inicio de sesión ([SignInPage]).
class SplashPage extends StatefulWidget {
  /// Crea una instancia de [SplashPage].
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// Estado para [SplashPage] que maneja la animación del logo y la navegación.
class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Duración de la animación
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack), // Efecto de escala con rebote
    );

    _animationController.forward(); // Inicia la animación

    _navigateToNextScreen();
  }

  /// Navega a la [SignInPage] después de una demora.
  /// La demora debe ser igual o mayor que la duración de la animación.
  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () { // 3 segundos de splash en total
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Libera el controlador de animación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: AppColors.primary, 
        ),
        child: Center(
          // Aplicar las transiciones al logo
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                AppStrings.logo,
                width: AppDimens.logoWidth, 
                height: AppDimens.logoHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
