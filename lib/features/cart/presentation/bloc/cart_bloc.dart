import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/helpers/cart_model_mapper.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/cart_state.dart';

/// BLoC que maneja la lógica del carrito de compras
class CartBloc extends Bloc<CartEvent, CartState> {
  // Casos de uso para operaciones API
  final GetMyCartUseCase? getMyCartUseCase;
  final AddItemToCartUseCase? addItemToCartUseCase;
  final UpdateCartItemUseCase? updateCartItemUseCase;
  final RemoveCartItemUseCase? removeCartItemUseCase;
  final ClearCartUseCase? clearCartUseCase;

  CartBloc({
    this.getMyCartUseCase,
    this.addItemToCartUseCase,
    this.updateCartItemUseCase,
    this.removeCartItemUseCase,
    this.clearCartUseCase,
  }) : super(const CartInitial()) {
    on<CartLoadRequested>(_onCartLoadRequested);
    on<CartLoadFromApiRequested>(_onCartLoadFromApiRequested);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemAddedToApi>(_onCartItemAddedToApi);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemRemovedFromApi>(_onCartItemRemovedFromApi);
    on<CartItemQuantityUpdated>(_onCartItemQuantityUpdated);
    on<CartItemQuantityUpdatedInApi>(_onCartItemQuantityUpdatedInApi);
    on<CartCleared>(_onCartCleared);
    on<CartClearedFromApi>(_onCartClearedFromApi);
  }

  /// Carga los ítems del carrito (método local existente)
  void _onCartLoadRequested(CartLoadRequested event, Emitter<CartState> emit) {
    emit(const CartLoading());
    try {
      // Si tenemos casos de uso de API, cargar desde API
      if (getMyCartUseCase != null) {
        add(const CartLoadFromApiRequested());
      } else {
        // Cargar carrito vacío como fallback
        emit(const CartLoaded());
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  /// Carga el carrito desde la API
  void _onCartLoadFromApiRequested(
    CartLoadFromApiRequested event,
    Emitter<CartState> emit,
  ) async {
    if (getMyCartUseCase == null) {
      emit(const CartError(message: 'API no disponible para cargar carrito'));
      return;
    }

    emit(const CartLoading());
    
    try {
      final result = await getMyCartUseCase!.execute();
      
      result.fold(
        (failure) {
          AppLogger.logError('Error al cargar carrito desde API: ${failure.message}');
          emit(CartError(message: failure.message));
        },
        (cartApi) {
          AppLogger.logSuccess('Carrito cargado desde API: ${cartApi.items.length} items');
          
          // Convertir items de API a modelos de dominio
          final domainItems = CartModelMapper.fromApiItems(cartApi.items);
          
          emit(CartLoaded(items: domainItems));
        },
      );
    } catch (e) {
      AppLogger.logError('Error inesperado al cargar carrito: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Añade un ítem al carrito (método local existente)
  void _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      try {
        final currentState = state as CartLoaded;
        final newItem = CartItemModel(
          product: event.product,
          size: event.size,
          color: event.color,
          quantity: event.quantity,
        );

        // Verificar si el producto ya existe en el carrito (mismo producto, talla y color)
        final existingItemIndex = currentState.items.indexWhere(
          (item) => item.id == newItem.id,
        );

        if (existingItemIndex >= 0) {
          // Si ya existe, actualizamos la cantidad
          final existingItem = currentState.items[existingItemIndex];
          final updatedItem = existingItem.copyWith(
            quantity: existingItem.quantity + event.quantity,
          );

          final updatedItems = List<CartItemModel>.from(currentState.items);
          updatedItems[existingItemIndex] = updatedItem;

          emit(CartLoaded(items: updatedItems));
        } else {
          // Si no existe, lo añadimos como nuevo ítem
          emit(CartLoaded(items: [...currentState.items, newItem]));
        }
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    }
  }

  /// Añade un ítem al carrito usando la API
  void _onCartItemAddedToApi(
    CartItemAddedToApi event,
    Emitter<CartState> emit,
  ) async {
    if (addItemToCartUseCase == null) {
      emit(const CartError(message: 'API no disponible para añadir item'));
      return;
    }

    try {
      AppLogger.logInfo('Añadiendo item al carrito via API: ${event.productVariantId}');
      
      final result = await addItemToCartUseCase!.execute(
        event.productVariantId,
        event.quantity,
      );

      result.fold(
        (failure) {
          AppLogger.logError('Error al añadir item al carrito: ${failure.message}');
          emit(CartError(message: failure.message));
        },
        (cartApi) {
          AppLogger.logSuccess('Item añadido al carrito exitosamente');
          
          // Convertir items de API a modelos de dominio
          final domainItems = CartModelMapper.fromApiItems(cartApi.items);
          
          emit(CartLoaded(items: domainItems));
        },
      );
    } catch (e) {
      AppLogger.logError('Error inesperado al añadir item: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Elimina un ítem del carrito (método local existente)
  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      try {
        final currentState = state as CartLoaded;
        final updatedItems =
            currentState.items
                .where((item) => item.id != event.itemId)
                .toList();
        emit(CartLoaded(items: updatedItems));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    }
  }

  /// Elimina un ítem del carrito usando la API
  void _onCartItemRemovedFromApi(
    CartItemRemovedFromApi event,
    Emitter<CartState> emit,
  ) async {
    if (removeCartItemUseCase == null) {
      emit(const CartError(message: 'API no disponible para eliminar item'));
      return;
    }

    try {
      AppLogger.logInfo('Eliminando item del carrito via API: ${event.apiItemId}');
      
      final result = await removeCartItemUseCase!.execute(event.apiItemId);

      result.fold(
        (failure) {
          AppLogger.logError('Error al eliminar item del carrito: ${failure.message}');
          emit(CartError(message: failure.message));
        },
        (cartApi) {
          AppLogger.logSuccess('Item eliminado del carrito exitosamente');
          
          // Convertir items de API a modelos de dominio
          final domainItems = CartModelMapper.fromApiItems(cartApi.items);
          
          emit(CartLoaded(items: domainItems));
        },
      );
    } catch (e) {
      AppLogger.logError('Error inesperado al eliminar item: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Actualiza la cantidad de un ítem en el carrito (método local existente)
  void _onCartItemQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) {
    if (state is CartLoaded) {
      try {
        final currentState = state as CartLoaded;
        final itemIndex = currentState.items.indexWhere(
          (item) => item.id == event.itemId,
        );

        if (itemIndex >= 0) {
          final item = currentState.items[itemIndex];

          if (event.newQuantity <= 0) {
            // Si la cantidad es 0 o menos, eliminamos el ítem
            final updatedItems = List<CartItemModel>.from(currentState.items)
              ..removeAt(itemIndex);
            emit(CartLoaded(items: updatedItems));
          } else {
            // Actualizamos la cantidad
            final updatedItem = item.copyWith(quantity: event.newQuantity);
            final updatedItems = List<CartItemModel>.from(currentState.items)
              ..[itemIndex] = updatedItem;
            emit(CartLoaded(items: updatedItems));
          }
        }
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    }
  }

  /// Actualiza la cantidad de un ítem en el carrito usando la API
  void _onCartItemQuantityUpdatedInApi(
    CartItemQuantityUpdatedInApi event,
    Emitter<CartState> emit,
  ) async {
    if (updateCartItemUseCase == null) {
      emit(const CartError(message: 'API no disponible para actualizar item'));
      return;
    }

    try {
      AppLogger.logInfo('Actualizando cantidad via API: ${event.apiItemId} -> ${event.newQuantity}');
      
      final result = await updateCartItemUseCase!.execute(
        event.apiItemId,
        event.newQuantity,
      );

      result.fold(
        (failure) {
          AppLogger.logError('Error al actualizar cantidad: ${failure.message}');
          emit(CartError(message: failure.message));
        },
        (cartApi) {
          AppLogger.logSuccess('Cantidad actualizada exitosamente');
          
          // Convertir items de API a modelos de dominio
          final domainItems = CartModelMapper.fromApiItems(cartApi.items);
          
          emit(CartLoaded(items: domainItems));
        },
      );
    } catch (e) {
      AppLogger.logError('Error inesperado al actualizar cantidad: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Vacía el carrito (método local existente)
  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      emit(const CartLoaded());
    }
  }

  /// Vacía el carrito usando la API
  void _onCartClearedFromApi(
    CartClearedFromApi event,
    Emitter<CartState> emit,
  ) async {
    if (clearCartUseCase == null) {
      emit(const CartError(message: 'API no disponible para vaciar carrito'));
      return;
    }

    try {
      AppLogger.logInfo('Vaciando carrito via API');
      
      final result = await clearCartUseCase!.execute();

      result.fold(
        (failure) {
          AppLogger.logError('Error al vaciar carrito: ${failure.message}');
          emit(CartError(message: failure.message));
        },
        (cartApi) {
          AppLogger.logSuccess('Carrito vaciado exitosamente');
          
          // Convertir items de API a modelos de dominio (debería estar vacío)
          final domainItems = CartModelMapper.fromApiItems(cartApi.items);
          
          emit(CartLoaded(items: domainItems));
        },
      );
    } catch (e) {
      AppLogger.logError('Error inesperado al vaciar carrito: $e');
      emit(CartError(message: e.toString()));
    }
  }
}
