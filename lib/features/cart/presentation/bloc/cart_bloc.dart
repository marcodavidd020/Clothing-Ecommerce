import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/cart_state.dart';

/// BLoC que maneja la lógica del carrito de compras
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {
    on<CartLoadRequested>(_onCartLoadRequested);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityUpdated>(_onCartItemQuantityUpdated);
    on<CartCleared>(_onCartCleared);
  }

  /// Carga los ítems del carrito (en un caso real, esto podría cargar desde una API o almacenamiento local)
  void _onCartLoadRequested(CartLoadRequested event, Emitter<CartState> emit) {
    emit(const CartLoading());
    try {
      // Aquí cargaríamos los ítems del carrito desde una fuente de datos
      // Por ahora, simplemente inicializamos un carrito vacío
      emit(const CartLoaded());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  /// Añade un ítem al carrito
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

  /// Elimina un ítem del carrito
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

  /// Actualiza la cantidad de un ítem en el carrito
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

  /// Vacía el carrito
  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      emit(const CartLoaded());
    }
  }
}
