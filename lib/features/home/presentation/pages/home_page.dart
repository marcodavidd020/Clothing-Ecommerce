import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';
import 'all_categories_page.dart'; // Importar la nueva página

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
  final ScrollController _scrollController = ScrollController();
  bool _showFade = true;

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
      additionalImageUrls: [
        'https://static.vecteezy.com/system/resources/previews/008/530/102/original/sport-t-shirt-cutout-file-png.png',
        'https://static.vecteezy.com/system/resources/previews/008/530/103/original/sport-t-shirt-cutout-file-png.png',
      ],
      price: 148.00,
      averageRating: 4.5,
      reviewCount: 120,
      description:
          "Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you room to layer, while the soft corduroy keeps you comfortable around the clock. Inspired by classic workwear, it's a timeless piece you can count on for years to come.",
      availableSizes: ["S", "M", "L", "XL"],
      availableColors: [
        ProductColorOption(name: "Green", color: Colors.green.shade300),
        ProductColorOption(name: "Black", color: Colors.black),
        ProductColorOption(name: "Beige", color: Colors.brown.shade200),
      ],
    ),
    ProductItemModel(
      id: '2',
      name: "Max Cirro Men's Slides",
      imageUrl:
          'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1663099829-sandal-slides-for-men-1663099812.jpg?crop=1xw:1xh;center,top&resize=980:*',
      additionalImageUrls: [
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/abc77aa4-1731-4591-bd65-55f4179026d7/max-cirro-mens-slides-sM9N3M.png',
      ],
      price: 55.00,
      originalPrice: 100.97,
      averageRating: 4.0,
      reviewCount: 85,
      description:
          "Ultra-comfortable and easy to wear, these slides are perfect for relaxing or running errands. The plush strap and contoured footbed provide all-day comfort.",
      availableSizes: ["8", "9", "10", "11", "12"],
      availableColors: [
        ProductColorOption(name: "Black/White", color: Colors.black),
        ProductColorOption(name: "Red", color: Colors.red),
      ],
    ),
    ProductItemModel(
      id: '3',
      name: "Modern Fit Denim Shirt",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 79.99,
      averageRating: 3.5,
      reviewCount: 45,
    ),
    ProductItemModel(
      id: '4',
      name: "Classic Cotton Polo",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 45.50,
      originalPrice: 65.00,
      averageRating: 5.0,
      reviewCount: 210,
    ),
  ];

  // Lista de productos para la sección New In
  final List<ProductItemModel> _newInProducts = [
    ProductItemModel(
      id: '5',
      name: "Essential Crewneck T-Shirt",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      additionalImageUrls: [],
      price: 29.99,
      averageRating: 4.2,
      reviewCount: 90,
      description:
          "A classic crewneck t-shirt made from soft, breathable cotton. A staple for any wardrobe.",
      availableSizes: ["XS", "S", "M", "L"],
      availableColors: [
        ProductColorOption(name: "White", color: Colors.white),
        ProductColorOption(name: "Black", color: Colors.black),
        ProductColorOption(name: "Navy", color: Colors.blue.shade900),
      ],
    ),
    ProductItemModel(
      id: '6',
      name: "Lightweight Running Shorts",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 39.99,
      originalPrice: 49.99,
      averageRating: 3.8,
      reviewCount: 60,
    ),
    ProductItemModel(
      id: '7',
      name: "Urban Backpack",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 59.99,
      averageRating: 4.9,
      reviewCount: 150,
    ),
    ProductItemModel(
      id: '8',
      name: "Classic Sneakers",
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: 89.99,
      originalPrice: 120.00,
      averageRating: 4.3,
      // reviewCount: null, // Ejemplo sin conteo de reseñas
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Umbral para considerar que se ha llegado al final (evita parpadeos)
    const double scrollThreshold = 10.0;
    // Comprueba si la posición actual del scroll está cerca del final máximo
    bool isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - scrollThreshold;

    // Si el estado del difuminado necesita cambiar, actualiza el estado
    if (isAtBottom && _showFade) {
      setState(() {
        _showFade = false;
      });
    } else if (!isAtBottom && !_showFade) {
      setState(() {
        _showFade = true;
      });
    }
  }

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCategoriesPage(categories: _categories),
      ),
    );
    print("Botón 'See All Categories' presionado!");
  }

  /// Callback para cuando se presiona un ítem de categoría individual.
  void _onCategoryTapped(CategoryItemModel category) {
    // Lógica de demostración para obtener productos para la categoría seleccionada.
    // En una app real, esto vendría de un BLoC o servicio que filtre productos.
    final List<ProductItemModel> categoryProducts =
        _topSellingProducts // Usamos una lista existente como ejemplo
            .where(
              (p) => p.name.toLowerCase().contains(
                category.name.toLowerCase().substring(0, 3),
              ),
            ) // Simulación de filtro
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CategoryProductsPage(
              category: category,
              products:
                  categoryProducts.isNotEmpty
                      ? categoryProducts
                      : _topSellingProducts.take(2).toList(), // Fallback
            ),
      ),
    );
    print("Categoría presionada desde Home: ${category.name}");
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
      body: SafeArea(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  _showFade
                      ? [Colors.white, Colors.white.withOpacity(0.0)]
                      : [
                        Colors.white,
                        Colors.white,
                      ], // Sin difuminado si está al final
              stops:
                  _showFade
                      ? const [
                        AppDimens.homeContentFadeStart,
                        AppDimens.homeContentFadeEnd,
                      ]
                      : null, // No se necesitan stops si no hay gradiente de opacidad
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: SingleChildScrollView(
            controller: _scrollController, // Asignar el controller
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
                vertical: AppDimens.vSpace16,
              ),
              child: AnimatedStaggeredList(
                // Puedes ajustar staggerDuration, itemDelay, initialOffsetY si es necesario
                children: [
                  SearchBarWidget(
                    onTap:
                        _onSearchTapped, // Actualmente funciona como un botón
                  ),
                  const SizedBox(height: AppDimens.vSpace16),
                  CategoriesSectionWidget(
                    categories: _categories,
                    onSeeAllPressed: _onSeeAllCategoriesPressed,
                    onCategoryTap: _onCategoryTapped,
                  ),
                  const SizedBox(
                    height: AppDimens.vSpace16,
                  ), // Espacio entre secciones
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
                        final index = _topSellingProducts.indexWhere(
                          (p) => p.id == product.id,
                        );
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
                      print(
                        'Favorito presionado: ${product.name}, es favorito: ${!product.isFavorite}',
                      );
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
                        final index = _newInProducts.indexWhere(
                          (p) => p.id == product.id,
                        );
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
                      print(
                        'Favorito New In presionado: \\${product.name}, es favorito: \\${!product.isFavorite}',
                      );
                    },
                  ),
                  // const SizedBox(height: AppDimens.vSpace16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
