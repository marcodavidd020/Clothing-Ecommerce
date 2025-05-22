import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

// Importar mixins con manejadores
import 'handlers/home_handlers.dart';
import 'handlers/category_handlers.dart';
import 'handlers/product_handlers.dart';
import 'handlers/favorite_handlers.dart';

// Importar eventos
import 'events/home_event.dart';
import 'events/category_events.dart';
import 'events/product_events.dart';
import 'events/favorite_events.dart';

// Importar estados
import 'states/home_state.dart';

/// BLoC para manejar el estado de la pantalla de inicio
///
/// Gestiona la carga y actualización de categorías, productos,
/// detalles de producto y gestión de favoritos.
class HomeBloc extends Bloc<HomeEvent, HomeState>
    with
        HomeEventHandlers,
        CategoryEventHandlers,
        ProductEventHandlers,
        FavoriteEventHandlers {
  // Casos de uso
  @override
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  @override
  final GetApiCategoriesTreeUseCase getApiCategoriesTreeUseCase;

  @override
  final GetCategoryByIdUseCase getCategoryByIdUseCase;

  @override
  final GetProductByIdUseCase getProductByIdUseCase;

  /// Constructor del HomeBloc que inicializa los casos de uso y registra los manejadores de eventos
  HomeBloc({
    required this.getProductsByCategoryUseCase,
    required this.getApiCategoriesTreeUseCase,
    required this.getCategoryByIdUseCase,
    required this.getProductByIdUseCase,
  }) : super(HomeInitial()) {
    // Registrar manejadores de eventos
    _registerEventHandlers();
  }

  /// Registra todos los manejadores de eventos
  void _registerEventHandlers() {
    // Eventos de página principal
    on<LoadHomeDataEvent>(onLoadHomeData);

    // Eventos de categorías
    on<LoadCategoriesEvent>(onLoadCategories);
    on<LoadApiCategoriesTreeEvent>(onLoadApiCategoriesTree);
    on<LoadCategoryByIdEvent>(onLoadCategoryById);
    on<SelectRootCategoryEvent>(onSelectRootCategory);

    // Eventos de productos
    on<LoadProductsByCategoryEvent>(onLoadProductsByCategory);
    on<LoadProductByIdEvent>(onLoadProductById);

    // Eventos de favoritos
    on<ToggleFavoriteEvent>(onToggleFavorite);
  }
}
