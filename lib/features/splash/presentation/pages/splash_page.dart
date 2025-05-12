import 'dart:async'; // Necesario para Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

/// Página de Splash (pantalla de carga inicial) de la aplicación.
///
/// Muestra un logo animado durante un tiempo determinado y luego
/// navega a la pantalla principal.
class SplashPage extends StatefulWidget {
  /// Crea una instancia de [SplashPage].
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// Estado para [SplashPage] que maneja la animación del logo y la navegación.
class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  /// Configura las animaciones para el logo.
  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  /// Programa la navegación a la siguiente pantalla después de un retraso.
  ///
  /// Espera un tiempo suficiente para mostrar la animación del splash
  /// y luego navega a la pantalla principal usando GoRouter.
  void _navigateToNextScreen() {
    // Esperar 2 segundos antes de navegar a la siguiente pantalla
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed(AppRoutes.mainName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(AppStrings.logo, width: 200),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
