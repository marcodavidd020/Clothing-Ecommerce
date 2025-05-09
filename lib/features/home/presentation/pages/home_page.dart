import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import '../widgets/categories_section_widget.dart'; // Importación directa

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedGender = "Men";

  final List<CategoryItemModel> _categories = [
    CategoryItemModel(imageUrl: "https://pvh-brands.imgix.net/catalog/product/media/DM0DM19741_C8T_MO-ST-F1_099.jpg?w=&h=&crop=edges&fit=crop&auto=compress&auto=format", name: AppStrings.hoodiesLabel),
    CategoryItemModel(imageUrl: "https://duer.ca/cdn/shop/products/MSTS1013-LIVE-LITE-JOURNEY-SHORT-SAPPHIRE_7___FT_1.jpg?v=1743715634&width=1200", name: AppStrings.shortsLabel),
    CategoryItemModel(imageUrl: "https://images.ctfassets.net/hnk2vsx53n6l/3hw2iDbUASUCISMRCQZu1d/b8e1d9bf0c5b895f42159ab1d7505016/c57f27605095ed093092327ad747982c2ce4bf7d.png?fm=webp", name: AppStrings.shoesLabel),
    CategoryItemModel(imageUrl: "https://www.zaappy.com/cdn/shop/products/2_50e00087-247a-4e62-b1b0-530a7cb59ed7.jpg?v=1674566146", name: AppStrings.bagLabel),
    CategoryItemModel(imageUrl: "https://media.endclothing.com/media/f_auto,q_auto:eco,w_400,h_400/prodmedia/media/catalog/product/1/9/19-03-25-TC_OERI008C99PLA0041007_2_1.jpg", name: AppStrings.accessoriesLabel),
  ];

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

  void _onSeeAllCategoriesPressed(){
    print("See All Categories pressed!");
  }

  void _onCategoryTapped(CategoryItemModel category){
    print("Category tapped: ${category.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: false,
        onBagPressed: _onBagPressed,
        profileImageUrl: AppStrings.userPlaceholderIcon,
        onProfilePressed: _onProfilePressed,
        title: GenderSelectorButton(
          selectedGender: _selectedGender,
          onPressed: () {
            if (_selectedGender == "Men") {
              _selectGender("Women");
            } else {
              _selectGender("Men");
            }
          },
        ),
      ),
      body: SingleChildScrollView( // Para permitir scroll si el contenido es largo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
                vertical: AppDimens.vSpace16,
              ),
              child: SearchBarWidget(
                onTap: _onSearchTapped,
              ),
            ),
            CategoriesSectionWidget(
              categories: _categories,
              onSeeAllPressed: _onSeeAllCategoriesPressed,
              onCategoryTap: _onCategoryTapped,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.screenPadding),
              child: Center(
                child: Text('Contenido principal para $_selectedGender'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
