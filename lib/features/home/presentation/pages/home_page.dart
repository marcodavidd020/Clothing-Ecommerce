import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import '../widgets/categories_section_widget.dart'; // Importación directa

/// Página principal (Home) de la aplicación.
///
/// Muestra un selector de género en el AppBar, una barra de búsqueda,
/// una sección de categorías de productos y el contenido principal de la página.
class HomePage extends StatefulWidget {
  /// Crea una instancia de [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Género actualmente seleccionado para filtrar contenido (ej. "Men", "Women").
  String _selectedGender = "Men"; // Podría ser una constante de AppStrings

  // Lista de datos de ejemplo para las categorías.
  // En una aplicación real, esto vendría de un repositorio/API.
  final List<CategoryItemModel> _categories = [
    CategoryItemModel(imageUrl: "https://pvh-brands.imgix.net/catalog/product/media/DM0DM19741_C8T_MO-ST-F1_099.jpg?w=&h=&crop=edges&fit=crop&auto=compress&auto=format", name: AppStrings.hoodiesLabel),
    CategoryItemModel(imageUrl: "https://duer.ca/cdn/shop/products/MSTS1013-LIVE-LITE-JOURNEY-SHORT-SAPPHIRE_7___FT_1.jpg?v=1743715634&width=1200", name: AppStrings.shortsLabel),
    CategoryItemModel(imageUrl: "https://images.ctfassets.net/hnk2vsx53n6l/3hw2iDbUASUCISMRCQZu1d/b8e1d9bf0c5b895f42159ab1d7505016/c57f27605095ed093092327ad747982c2ce4bf7d.png?fm=webp", name: AppStrings.shoesLabel),
    CategoryItemModel(imageUrl: "https://www.zaappy.com/cdn/shop/products/2_50e00087-247a-4e62-b1b0-530a7cb59ed7.jpg?v=1674566146", name: AppStrings.bagLabel),
    CategoryItemModel(imageUrl: "https://media.endclothing.com/media/f_auto,q_auto:eco,w_400,h_400/prodmedia/media/catalog/product/1/9/19-03-25-TC_OERI008C99PLA0041007_2_1.jpg", name: AppStrings.accessoriesLabel),
  ];

  /// Actualiza el género seleccionado y reconstruye el widget.
  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    // TODO: Implementar lógica para cambiar el contenido de la página basado en el género.
    print("Género seleccionado: $gender");
  }

  /// Callback para el botón de la bolsa de compras en el AppBar.
  void _onBagPressed() {
    // TODO: Implementar navegación a la pantalla de la bolsa/carrito.
    print("Botón de bolsa presionado!");
  }

  /// Callback para el botón de perfil en el AppBar.
  void _onProfilePressed() {
    // TODO: Implementar navegación a la pantalla de perfil de usuario.
    print("Botón de perfil presionado!");
  }

  /// Callback para cuando se presiona la barra de búsqueda.
  /// Actualmente actúa como un botón.
  void _onSearchTapped() {
    // TODO: Implementar navegación a una pantalla de búsqueda dedicada o activar campo de texto.
    print("Barra de búsqueda presionada!");
  }

  /// Callback para el botón "See All" en la sección de categorías.
  void _onSeeAllCategoriesPressed() {
    // TODO: Implementar navegación a una pantalla que muestre todas las categorías.
    print("Botón 'See All Categories' presionado!");
  }

  /// Callback para cuando se presiona un ítem de categoría individual.
  void _onCategoryTapped(CategoryItemModel category) {
    // TODO: Implementar navegación a la pantalla de listado de productos para esa categoría.
    print("Categoría presionada: ${category.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: false, // No se necesita botón de retroceso en la HomePage principal
        onBagPressed: _onBagPressed,
        profileImageUrl: AppStrings.userPlaceholderIcon, // Placeholder, usar imagen real del usuario
        onProfilePressed: _onProfilePressed,
        title: GenderSelectorButton(
          selectedGender: _selectedGender,
          onPressed: () {
            // Lógica simple para alternar género, podría ser un Dropdown o BottomSheet.
            if (_selectedGender == "Men") { // Considerar usar constantes para "Men"/"Women"
              _selectGender("Women");
            } else {
              _selectGender("Men");
            }
          },
        ),
      ),
      body: SingleChildScrollView( // Permite el scroll si el contenido es más largo que la pantalla
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
                vertical: AppDimens.vSpace16,
              ),
              child: SearchBarWidget(
                onTap: _onSearchTapped, // Actualmente funciona como un botón
              ),
            ),
            // Sección de categorías
            CategoriesSectionWidget(
              categories: _categories,
              onSeeAllPressed: _onSeeAllCategoriesPressed,
              onCategoryTap: _onCategoryTapped,
            ),
            // Espacio para el contenido principal de la página (ej. listado de productos)
            Padding(
              padding: const EdgeInsets.all(AppDimens.screenPadding),
              child: Center(
                child: Text('Contenido principal para $_selectedGender'), // Placeholder
              ),
            ),
          ],
        ),
      ),
    );
  }
}
