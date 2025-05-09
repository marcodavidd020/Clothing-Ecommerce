import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_application_ecommerce/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.light,
      // home: const MainShellPage(),
      home: const SplashPage(),
    );
  }
}
