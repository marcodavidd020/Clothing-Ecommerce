import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedGender = AppStrings.menTitle;

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    // Lógica para cambiar el contenido basado en el género
  }

  void _onBagPressed() {
    // Lógica para cuando se presiona el botón de la bolsa
    print("Bag button pressed!");
  }

  void _onProfilePressed() {
    // Lógica para cuando se presiona el botón de perfil
    print("Profile button pressed!");
  }

  void _onSearchTapped() {
    // Lógica para cuando se tapea la barra de búsqueda (ej: navegar a pantalla de búsqueda)
    print("Search bar tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: false, // O true si necesitas un botón de back específico aquí
        onBagPressed: _onBagPressed,
        profileImageUrl: AppStrings.userPlaceholderIcon, // Usar imagen real cuando esté disponible
        onProfilePressed: _onProfilePressed,
        title: GenderSelectorButton(
          selectedGender: _selectedGender,
          onPressed: () {
            // Aquí podrías mostrar un Dropdown, un BottomSheet o navegar a otra página
            // para seleccionar el género. Por ahora, solo cambiaremos entre Men/Women como ejemplo.
            if (_selectedGender == AppStrings.menTitle) {
              _selectGender(AppStrings.womenTitle);
            } else {
              _selectGender(AppStrings.menTitle);
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
              vertical: AppDimens.vSpace16,
            ),
            child: SearchBarWidget(
              onTap: _onSearchTapped, // Hace que actúe como un botón por ahora
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Contenido para $_selectedGender'),
            ),
          ),
        ],
      ),
    );
  }
}
