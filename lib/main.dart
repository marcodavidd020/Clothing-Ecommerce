import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';
import 'package:flutter_application_ecommerce/core/di/service_locator.dart';
import 'package:flutter_application_ecommerce/core/di/modules/bloc_module.dart';
import 'package:flutter_application_ecommerce/core/di/modules/repository_module.dart';

/// Función principal que ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el módulo de almacenamiento antes que otros módulos
  await ServiceLocator.init(initializeStorage: true);

  runApp(const AppRoot());
}

/// Widget raíz que provee todos los BLoCs necesarios
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: RepositoryModule.providers,
      child: MultiBlocProvider(
        providers: BlocModule.providers(context, ServiceLocator.sl),
        child: const MyApp(),
      ),
    );
  }
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
