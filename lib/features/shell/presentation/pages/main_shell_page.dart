import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_ecommerce/features/profile/profile.dart';

/// Widget principal que actúa como un "caparazón" (shell) para la navegación
/// principal de la aplicación mediante una [BottomNavigationBarWidget].
///
/// Gestiona el estado de la pestaña actual y muestra la página correspondiente.
/// Esta implementación reemplaza a ShellPage y ya no utiliza GoRouter.
class MainShellPage extends StatefulWidget {
  /// Crea una instancia de [MainShellPage].
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  /// Índice de la pestaña actualmente seleccionada en la barra de navegación.
  int _currentIndex = 0;

  /// Lista de widgets (páginas) que se mostrarán según la selección en la barra de navegación.
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Notifications Page')), // Placeholder para la página de Notificaciones
    const Center(child: Text('Receipts Page')),      // Placeholder para la página de Recibos/Pedidos
    const ProfilePage(),        // Reemplazar Placeholder con ProfilePage
  ];

  /// Cambia la página actual cuando se selecciona un ítem en la barra de navegación.
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack se utiliza para mantener el estado de cada página
      // cuando se cambia entre pestañas. Esto es útil si las páginas
      // tienen su propio estado interno que no se quiere perder.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Barra de navegación inferior personalizada.
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
