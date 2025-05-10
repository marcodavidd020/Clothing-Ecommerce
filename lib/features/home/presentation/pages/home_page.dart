import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';

/// Página principal (Home) de la aplicación.
///
/// Muestra un selector de género en el AppBar, una barra de búsqueda,
/// una sección de categorías de productos y el contenido principal de la página,
/// todos con animaciones de entrada.
class HomePage extends StatefulWidget {
  /// Crea una instancia de [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Estado para [HomePage] que maneja la lógica de la UI.
/// Las animaciones de entrada ahora son gestionadas por [AnimatedStaggeredList].
class _HomePageState extends State<HomePage> {
  /// Género actualmente seleccionado para filtrar contenido (ej. "Men", "Women").
  String _selectedGender = "Men"; // Podría ser una constante de AppStrings

  // Lista de categorías para el demo
  final List<CategoryItemModel> _categories = [
    CategoryItemModel(
      imageUrl:
          "https://pvh-brands.imgix.net/catalog/product/media/DM0DM19741_C8T_MO-ST-F1_099.jpg?w=&h=&crop=edges&fit=crop&auto=compress&auto=format",
      name: AppStrings.hoodiesLabel,
    ),
    CategoryItemModel(
      imageUrl:
          "https://duer.ca/cdn/shop/products/MSTS1013-LIVE-LITE-JOURNEY-SHORT-SAPPHIRE_7___FT_1.jpg?v=1743715634&width=1200",
      name: AppStrings.shortsLabel,
    ),
    CategoryItemModel(
      imageUrl:
          "https://images.ctfassets.net/hnk2vsx53n6l/3hw2iDbUASUCISMRCQZu1d/b8e1d9bf0c5b895f42159ab1d7505016/c57f27605095ed093092327ad747982c2ce4bf7d.png?fm=webp",
      name: AppStrings.shoesLabel,
    ),
    CategoryItemModel(
      imageUrl:
          "https://www.zaappy.com/cdn/shop/products/2_50e00087-247a-4e62-b1b0-530a7cb59ed7.jpg?v=1674566146",
      name: AppStrings.bagLabel,
    ),
    CategoryItemModel(
      imageUrl:
          "https://media.endclothing.com/media/f_auto,q_auto:eco,w_400,h_400/prodmedia/media/catalog/product/1/9/19-03-25-TC_OERI008C99PLA0041007_2_1.jpg",
      name: AppStrings.accessoriesLabel,
    ),
  ];

  // Lista de productos de demostración
  final List<ProductItemModel> _topSellingProducts = [
    ProductItemModel(
      id: '1',
      name: "Men's Harrington Jacket",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 148.00,
    ),
    ProductItemModel(
      id: '2',
      name: "Max Cirro Men's Slides",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 55.00,
      originalPrice: 100.97,
    ),
    ProductItemModel(
      id: '3',
      name: "Modern Fit Denim Shirt",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 79.99,
    ),
    ProductItemModel(
      id: '4',
      name: "Classic Cotton Polo",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 45.50,
      originalPrice: 65.00,
    ),
  ];

  // Lista de productos para la sección New In
  final List<ProductItemModel> _newInProducts = [
    ProductItemModel(
      id: '5',
      name: "Essential Crewneck T-Shirt",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 29.99,
    ),
    ProductItemModel(
      id: '6',
      name: "Lightweight Running Shorts",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 39.99,
      originalPrice: 49.99,
    ),
    ProductItemModel(
      id: '7',
      name: "Urban Backpack",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 59.99,
    ),
    ProductItemModel(
      id: '8',
      name: "Classic Sneakers",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 89.99,
      originalPrice: 120.00,
    ),
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
        showBack:
            false, // No se necesita botón de retroceso en la HomePage principal
        onBagPressed: _onBagPressed,
        profileImageUrl:
            AppStrings
                .userPlaceholderIcon, // Placeholder, usar imagen real del usuario
        onProfilePressed: _onProfilePressed,
        title: GenderSelectorButton(
          selectedGender: _selectedGender,
          onPressed: () {
            // Lógica simple para alternar género, podría ser un Dropdown o BottomSheet.
            if (_selectedGender == "Men") {
              // Considerar usar constantes para "Men"/"Women"
              _selectGender("Women");
            } else {
              _selectGender("Men");
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        // Permite el scroll si el contenido es más largo que la pantalla
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
            vertical: AppDimens.vSpace16,
          ),
          child: AnimatedStaggeredList(
            // Puedes ajustar staggerDuration, itemDelay, initialOffsetY si es necesario
            children: [
              SearchBarWidget(
                onTap: _onSearchTapped, // Actualmente funciona como un botón
              ),
              const SizedBox(height: AppDimens.vSpace16),
              CategoriesSectionWidget(
                categories: _categories,
                onSeeAllPressed: _onSeeAllCategoriesPressed,
                onCategoryTap: _onCategoryTapped,
              ),
              const SizedBox(height: AppDimens.vSpace16), // Espacio entre secciones
              ProductHorizontalListSection(
                products: _topSellingProducts,
                onSeeAllPressed: () {
                  // TODO: Implementar navegación a "See All" de Top Selling
                  print('See All Top Selling presionado');
                },
                onProductTap: (product) {
                  // TODO: Implementar navegación al detalle del producto
                  print('Producto presionado: ${product.name}');
                },
                onFavoriteToggle: (product) {
                  setState(() {
                    final index = _topSellingProducts.indexWhere((p) => p.id == product.id);
                    if (index != -1) {
                      _topSellingProducts[index] = ProductItemModel(
                        id: product.id,
                        name: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        isFavorite: !product.isFavorite,
                      );
                    }
                  });
                  print('Favorito presionado: ${product.name}, es favorito: ${!product.isFavorite}');
                },
              ),
              const SizedBox(height: AppDimens.vSpace16),
              // Sección New In
              ProductHorizontalListSection(
                title: AppStrings.newInTitle,
                titleColor: AppColors.primary,
                products: _newInProducts,
                onSeeAllPressed: () {
                  // TODO: Implementar navegación a "See All" de New In
                  print('See All New In presionado');
                },
                onProductTap: (product) {
                  // TODO: Implementar navegación al detalle del producto
                  print('Producto New In presionado: \\${product.name}');
                },
                onFavoriteToggle: (product) {
                  setState(() {
                    final index = _newInProducts.indexWhere((p) => p.id == product.id);
                    if (index != -1) {
                      _newInProducts[index] = ProductItemModel(
                        id: product.id,
                        name: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        isFavorite: !product.isFavorite,
                      );
                    }
                  });
                  print('Favorito New In presionado: \\${product.name}, es favorito: \\${!product.isFavorite}');
                },
              ),
              const SizedBox(height: AppDimens.vSpace16),
            ],
          ),
        ),
      ),
    );
  }
}
