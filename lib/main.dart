import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/di/injection_container.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';
import 'package:flutter_application_ecommerce/di_container.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:get_it/get_it.dart';

/// Función principal que ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Primero inicializamos el contenedor DIContainer (que gestiona el storage)
  await DIContainer.init();

  // Verificar si hay un token almacenado (para depuración)
  final authStorage = GetIt.instance<AuthStorage>();
  final token = await authStorage.getAccessToken();
  // print('🔒 Token disponible: ${token != null}');
  AppLogger.logInfo('🔒 Token disponible: ${token != null}');
  if (token != null) {
    AppLogger.logInfo('🔒 Token: ${token.substring(0, 15)}...');
  } else {
    AppLogger.logInfo('🔒 No hay token disponible, necesitas iniciar sesión');
  }

  // Inicializar el contenedor de inyección de dependencias
  final Widget app = await InjectionContainer.initAsync(child: const MyApp());

  runApp(app);
}

/// Widget raíz de la aplicación.
class MyApp extends StatelessWidget {
  /// Crea una instancia de MyApp.
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
