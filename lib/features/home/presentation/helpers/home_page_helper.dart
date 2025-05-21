import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/home_navigation_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper para la página Home con métodos específicos para manejar la lógica
/// de la página principal, organizada por responsabilidades.
class HomePageHelper {
  /// Constructor privado para prevenir instanciación
  HomePageHelper._();

  /// Solicita la carga inicial de datos para la página Home
  ///
  /// Verifica qué datos necesitan ser cargados según el estado actual
  /// y solicita solo lo necesario.
  static void requestInitialData(BuildContext context, bool dataRequested) {
    if (dataRequested) return;

    AppLogger.logInfo('Solicitando carga de datos iniciales para HomeBloc');

    // Usar microtask para no interferir con el frame actual
    Future.microtask(() {
      if (!context.mounted) return;

      final homeBloc = context.read<HomeBloc>();
      final currentState = homeBloc.state;

      // Solo cargar datos del Home si realmente no están disponibles
      if (currentState is! HomeLoaded) {
        _loadHomeData(context);
      } else {
        // Si ya tenemos datos pero faltan categorías del API, cargarlas
        if ((currentState as HomeLoaded).apiCategories.isEmpty) {
          _loadApiCategories(context);
        }
      }
    });
  }
  
  /// Carga los datos completos de la página Home
  static void _loadHomeData(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadHomeDataEvent());
  }
  
  /// Carga específicamente las categorías API
  static void _loadApiCategories(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadApiCategoriesTreeEvent());
  }

  /// Busca una categoría por ID en el árbol completo de categorías
  ///
  /// Recorre recursivamente todas las categorías raíz y sus subcategorías
  /// para encontrar la que coincida con el ID proporcionado.
  static CategoryApiModel? findCategoryById(
    List<CategoryApiModel> rootCategories,
    String categoryId,
  ) {
    // Para cada categoría raíz, buscar recursivamente
    for (final rootCategory in rootCategories) {
      final result = _searchCategoryRecursively(rootCategory, categoryId);
      if (result != null) return result;
    }
    return null;
  }

  /// Función recursiva para buscar una categoría por ID en el árbol
  static CategoryApiModel? _searchCategoryRecursively(
    CategoryApiModel category,
    String targetId,
  ) {
    // Verificar la categoría actual
    if (category.id == targetId) return category;

    // Buscar en los hijos recursivamente
    for (final child in category.children) {
      final result = _searchCategoryRecursively(child, targetId);
      if (result != null) return result;
    }

    // No se encontró coincidencia
    return null;
  }

  /// Maneja la navegación cuando se ha cargado una categoría específica
  static void handleCategoryLoaded(
    BuildContext context,
    CategoryApiModel category,
    List<CategoryApiModel> allCategories,
  ) {
    AppLogger.logInfo(
      'Categoría cargada, navegando a detalle: ${category.name}',
    );

    // Usar el helper de navegación para ir a la categoría
    HomeNavigationHelper.navigateAfterCategoryLoaded(
      context,
      category,
      allCategories,
    );
  }

  /// Maneja la navegación cuando se han cargado productos para una categoría
  static void handleProductsLoaded(
    BuildContext context,
    String categoryId,
    List<ProductItemModel> products,
  ) {
    // Solo navegamos si hay productos
    if (products.isEmpty) return;

    AppLogger.logInfo(
      'Productos cargados para categoría: $categoryId, ${products.length} productos',
    );

    // Buscamos la categoría correspondiente para mostrar detalles
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      // Encontrar la categoría por ID en todas las categorías
      final targetCategory = findCategoryById(
        homeState.apiCategories,
        categoryId,
      );

      // Si encontramos la categoría, navegar a ella
      if (targetCategory != null) {
        HomeNavigationHelper.navigateAfterCategoryLoaded(
          context,
          targetCategory,
          homeState.apiCategories,
        );
      }
    }
  }

  /// Maneja la acción de "Ver todas las categorías" según el estado actual
  static void handleSeeAllCategories(
    BuildContext context,
    CategoryApiModel? selectedCategory,
    List<CategoryApiModel> allCategories,
  ) {
    // Si hay una categoría seleccionada, mostramos sus subcategorías
    if (selectedCategory != null) {
      HomeNavigationHelper.navigateAfterCategoryLoaded(
        context,
        selectedCategory,
        allCategories,
      );
    } else {
      // Si no hay categoría seleccionada, mostramos todas las categorías
      HomeNavigationHelper.goToAllCategories(context);
    }
  }
} 