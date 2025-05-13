import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/presentation.dart';
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
/// Las animaciones de entrada ahora son gestionadas por [AnimatedStaggeredList].
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFade = true;

  /// Variable para prevenir navegaciones duplicadas
  bool _isNavigatingToDetail = false;

  /// Género actualmente seleccionado para filtrar contenido (ej. "Men", "Women").
  String _selectedGender = "Men"; // Podría ser una constante de AppStrings

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Disparar evento para cargar datos iniciales
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const double scrollThreshold = 10.0;
    bool isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - scrollThreshold;

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

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    // TODO: Implementar lógica para filtrar por género usando el BLoC
  }

  void _onBagPressed() {
    NavigationHelper.goToCart(context);
  }

  void _onProfilePressed() {
    // TODO: Implementar navegación a perfil
  }

  void _onSearchTapped() {
    // TODO: Implementar navegación a búsqueda
  }

  void _onSeeAllCategoriesPressed() {
    NavigationHelper.goToCategories(context);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      showBack: false,
      onBagPressed: _onBagPressed,
      profileImageUrl: AppStrings.userPlaceholderIcon,
      onProfilePressed: _onProfilePressed,
      title: GenderSelectorButton(
        selectedGender: _selectedGender,
        onPressed: () {
          _selectGender(_selectedGender == "Men" ? "Women" : "Men");
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: AppDimens.appBarActionRightPadding,
          ),
          child: CartBadgeWidget(
            onPressed: _onBagPressed,
          ),
        ),
      ],
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
          return _buildLoadedContent(state);
        }

        return const Center(child: Text('Estado no manejado'));
      },
    );
  }

  Widget _buildLoadedContent(HomeLoaded state) {
    return SafeArea(
      child: ShaderMask(
        shaderCallback: _buildShaderCallback,
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
              vertical: AppDimens.vSpace16,
            ),
            child: AnimatedStaggeredList(
              children: [
                _buildSearchBar(),
                const SizedBox(height: AppDimens.vSpace16),
                _buildCategoriesSection(state),
                const SizedBox(height: AppDimens.vSpace16),
                _buildTopSellingSection(state),
                const SizedBox(height: AppDimens.vSpace16),
                _buildNewInSection(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Shader _buildShaderCallback(Rect bounds) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: _showFade
          ? [Colors.white, Colors.white.withOpacity(0.0)]
          : [Colors.white, Colors.white],
      stops: _showFade
          ? const [
              AppDimens.homeContentFadeStart,
              AppDimens.homeContentFadeEnd,
            ]
          : null,
    ).createShader(bounds);
  }

  Widget _buildSearchBar() {
    return SearchBarWidget(onTap: _onSearchTapped);
  }

  Widget _buildCategoriesSection(HomeLoaded state) {
    return CategoriesSectionWidget(
      categories: state.categories,
      onSeeAllPressed: _onSeeAllCategoriesPressed,
      onCategoryTap: _onCategoryTapped,
    );
  }

  Widget _buildTopSellingSection(HomeLoaded state) {
    return ProductHorizontalListSection(
      products: state.topSellingProducts,
      onSeeAllPressed: () {
        // TODO: Implementar navegación a todos los productos más vendidos
      },
      onProductTap: _navigateToProductDetail,
      onFavoriteToggle: _onToggleFavorite,
    );
  }

  Widget _buildNewInSection(HomeLoaded state) {
    return ProductHorizontalListSection(
      title: AppStrings.newInTitle,
      titleColor: AppColors.primary,
      products: state.newInProducts,
      onSeeAllPressed: () {
        // TODO: Implementar navegación a todos los productos nuevos
      },
      onProductTap: _navigateToProductDetail,
      onFavoriteToggle: _onToggleFavorite,
    );
  }

  void _onToggleFavorite(ProductItemModel product) {
    context.read<HomeBloc>().add(
      ToggleFavoriteEvent(
        productId: product.id,
        isFavorite: !product.isFavorite,
      ),
    );
  }
}
