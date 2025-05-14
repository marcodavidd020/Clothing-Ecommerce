import 'dart:async'; // Necesario para Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar BlocProvider
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart'; // Importar AuthBloc y AuthEvent
import 'package:go_router/go_router.dart';

/// Página de Splash (pantalla de carga inicial) de la aplicación.
///
/// Muestra un logo animado, despacha un evento para verificar el estado de autenticación
/// y luego navega a la pantalla principal o de inicio de sesión según el resultado.
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
    // Despachar el evento para verificar el estado de autenticación
    context.read<AuthBloc>().add(CheckInitialAuthStatus());
    // La navegación ahora se maneja en el BlocListener
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

  // _navigateToNextScreen ya no es necesario aquí, se maneja con BlocListener

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Esperar un poco para que la animación del splash sea visible
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return; // Comprobar si el widget sigue montado

          if (state is Authenticated) {
            // Usar GoRouter para reemplazar la pila de navegación
            context.goNamed(AppRoutes.mainName);
          } else if (state is Unauthenticated) {
            // Usar GoRouter para reemplazar la pila de navegación
            context.goNamed(AppRoutes.signInName);
          }
          // No es necesario manejar RegistrationSuccessNeedSignIn explícitamente aquí,
          // ya que AuthBlocHandler lo llevará a SignInPage, y si luego el usuario
          // cierra la app y la vuelve a abrir, CheckInitialAuthStatus lo llevará a SignInPage.
        });
      },
      child: Scaffold(
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
      ),
    );
  }
}
