import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/core/di/di.dart';

/// Función principal que ejecuta la aplicación.
void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación.
class MyApp extends StatelessWidget {
  /// Crea una instancia de MyApp.
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return InjectionContainer.init(
      child: BlocProvider<CartBloc>(
        create: (context) => CartBloc()..add(const CartLoadRequested()),
        child: MaterialApp.router(
          title: 'Ecommerce App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // Usar GoRouter en lugar de navigatorKey y onGenerateRoute
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
