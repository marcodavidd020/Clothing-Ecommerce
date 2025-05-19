import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import '../../data/models/models.dart' show RegisterParams;
import '../../data/models/request/request.dart' show SignInParams;
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
    } else if (state is RegistrationSuccessNeedSignIn) {
      AuthUIHelpers.showSuccessMessage(
        context,
        "¡Registro exitoso! Por favor, inicia sesión.",
      );
      NavigationHelper.goToSignIn(context);
    } else if (state is AuthError) {
      AuthUIHelpers.showErrorMessage(context, state.message);
    } else if (state is Unauthenticated) {
      // Cerro Sesion
      AuthUIHelpers.showSuccessMessage(
        context,
        "¡Cerrando sesión! Hasta Pronto",
      );
      NavigationHelper.goToSignIn(context);
    }
  }

  /// Despacha evento de inicio de sesión al AuthBloc
  static void signIn(BuildContext context, {required SignInParams params}) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(SignInRequested(params: params));
  }

  /// Despacha evento de registro al AuthBloc
  static void register(BuildContext context, {required RegisterParams params}) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(RegisterRequested(params: params));
  }

  /// Despacha evento de cierre de sesión al AuthBloc
  static void signOut(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(SignOutRequested());
  }

  /// Verifica si el AuthBloc está en estado de carga
  static bool isLoading(AuthState state) => state is AuthLoading;
}
