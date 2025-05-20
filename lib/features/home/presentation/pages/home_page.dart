import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';

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
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  /// Variable para prevenir navegaciones duplicadas
  bool _isNavigatingToDetail = false;

  /// Género actualmente seleccionado para filtrar contenido (ej. "Men", "Women").
  String _selectedGender = "Men"; // Podría ser una constante de AppStrings

  @override
  void initState() {
    super.initState();
    // Disparar evento para cargar datos iniciales
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Cambia el género seleccionado y dispara evento para actualizar contenido
  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    // TODO: Implementar lógica para filtrar por género usando el BLoC
  }

  /// Navegación a la pantalla de carrito
  void _onBagPressed() {
    NavigationHelper.goToCart(context);
  }

  /// Navegación a la pantalla de perfil
  void _onProfilePressed() {
    // TODO: Implementar navegación a perfil
  }

  /// Navegación a la pantalla de búsqueda
  void _onSearchTapped() {
    // TODO: Implementar navegación a búsqueda
  }

  /// Navegación a la pantalla de todas las categorías
  void _onSeeAllCategoriesPressed() {
    NavigationHelper.goToCategories(context);
  }

  /// Navegación a la pantalla de todos los productos más vendidos
  void _onSeeAllTopSellingPressed() {
    // TODO: Implementar navegación a todos los productos más vendidos
  }

  /// Navegación a la pantalla de todos los productos nuevos
  void _onSeeAllNewInPressed() {
    // TODO: Implementar navegación a todos los productos nuevos
  }

  /// Carga productos filtrados por categoría
  void _onCategoryTapped(CategoryItemModel category) {
    // Usamos el nombre de la categoría como identificador
    context.read<HomeBloc>().add(
      LoadProductsByCategoryEvent(categoryId: category.name),
    );
  }

  /// Método para navegar al detalle del producto evitando duplicación
  void _navigateToProductDetail(ProductItemModel product) {
    if (_isNavigatingToDetail) return;

    _isNavigatingToDetail = true;
    NavigationHelper.goToProductDetail(context, product);
    _isNavigatingToDetail = false;
  }

  /// Cambia el estado de favorito de un producto
  void _onToggleFavorite(ProductItemModel product) {
    context.read<HomeBloc>().add(
      ToggleFavoriteEvent(
        productId: product.id,
        isFavorite: !product.isFavorite,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        selectedGender: _selectedGender,
        onGenderChanged: _selectGender,
        onBagPressed: _onBagPressed,
        onProfilePressed: _onProfilePressed,
        profileImageUrl: AppStrings.userPlaceholderIcon,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial || state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text(state.message));
        }

        if (state is HomeLoaded) {
          return HomeContentWidget(
            state: state,
            scrollController: _scrollController,
            onSearchTapped: _onSearchTapped,
            onSeeAllCategoriesPressed: _onSeeAllCategoriesPressed,
            onSeeAllTopSellingPressed: _onSeeAllTopSellingPressed,
            onSeeAllNewInPressed: _onSeeAllNewInPressed,
            onCategoryTapped: _onCategoryTapped,
            onProductTapped: _navigateToProductDetail,
            onToggleFavorite: _onToggleFavorite,
          );
        }

        return const Center(child: Text('Estado no manejado'));
      },
    );
  }
}
