/// Este es el archivo principal y punto de entrada para la aplicación Flutter.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/features/shell/presentation/pages/main_shell_page.dart';
import 'package:flutter_application_ecommerce/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Función principal que ejecuta la aplicación.
void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación.
///
/// Configura el [MaterialApp] con el tema global y la página inicial.
class MyApp extends StatelessWidget {
  /// Crea una instancia de MyApp.
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(const CartLoadRequested()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.light,
        // home: const SplashPage(),
        home: const MainShellPage(),
      ),
    );
  }
}
