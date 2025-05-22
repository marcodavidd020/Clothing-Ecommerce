import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/core/constants/auth_strings.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
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
      // Antes de navegar, garantizar que el HomeBloc está listo para cargar datos
      _resetHomeBloc();
      // Navegar a la página principal
      NavigationHelper.goToMainShell(context);
    } else if (state is RegistrationSuccessNeedSignIn) {
      AuthUIHelpers.showSuccessMessage(
        context,
        AuthStrings.registrationSuccess,
      );
      NavigationHelper.goToSignIn(context);
    } else if (state is AuthError) {
      AuthUIHelpers.showErrorMessage(context, state.message);
    } else if (state is Unauthenticated) {
      // Cerro Sesion
      AuthUIHelpers.showSuccessMessage(context, AuthStrings.logoutSuccess);
      NavigationHelper.goToSignIn(context);
    }
  }

  /// Reinicia el HomeBloc para forzar la carga de datos
  static void _resetHomeBloc() {
    try {
      // Verificar si el HomeBloc está registrado en GetIt
      if (GetIt.instance.isRegistered<HomeBloc>()) {
        // Obtener la instancia del bloc y enviar un evento de carga
        final homeBloc = GetIt.instance<HomeBloc>();
        if (!homeBloc.isClosed) {
          homeBloc.add(LoadHomeDataEvent());
        }
      }
    } catch (e) {
      debugPrint('Error al reiniciar HomeBloc: $e');
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
