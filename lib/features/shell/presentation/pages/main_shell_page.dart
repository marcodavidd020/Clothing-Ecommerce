import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/pages/home_page.dart';
// Importa aquí las otras páginas principales para la navegación
// import 'package:flutter_application_ecommerce/features/notifications/presentation/pages/notifications_page.dart';
// import 'package:flutter_application_ecommerce/features/receipts/presentation/pages/receipts_page.dart';
// import 'package:flutter_application_ecommerce/features/profile/presentation/pages/profile_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  // Lista de páginas para la barra de navegación
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Notifications Page')), // Placeholder
    const Center(child: Text('Receipts Page')), // Placeholder
    const Center(child: Text('Profile Page')), // Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Usa IndexedStack para mantener el estado de las páginas
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
