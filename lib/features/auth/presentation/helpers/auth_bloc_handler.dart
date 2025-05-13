import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'auth_ui_helpers.dart';

/// Clase auxiliar para manejar interacciones comunes con AuthBloc
class AuthBlocHandler {
  /// Constructor privado para prevenir instanciación
  AuthBlocHandler._();

  /// Escucha cambios en el AuthBloc y ejecuta acciones correspondientes
  ///
  /// Navega a MainShell cuando autenticado y muestra errores cuando hay fallos
  static void handleAuthState(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      NavigationHelper.goToMainShell(context);
    } else if (state is AuthError) {
      AuthUIHelpers.showErrorMessage(context, state.message);
    }
  }

  /// Despacha evento de inicio de sesión al AuthBloc
  static void signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(SignInRequested(email: email, password: password));
  }

  /// Despacha evento de registro al AuthBloc
  static void register(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(
      RegisterRequested(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      ),
    );
  }

  /// Despacha evento de cierre de sesión al AuthBloc
  static void signOut(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(SignOutRequested());
  }

  /// Verifica si el AuthBloc está en estado de carga
  static bool isLoading(AuthState state) => state is AuthLoading;
}
