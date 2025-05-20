import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/di/injection_container.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';

/// Función principal que ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el contenedor de inyección de dependencias
  final Widget app = await InjectionContainer.initAsync(
    child: const MyApp(),
  );

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
