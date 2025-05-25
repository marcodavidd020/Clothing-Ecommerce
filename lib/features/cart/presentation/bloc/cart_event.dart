import 'package:equatable/equatable.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

/// Eventos para el BLoC del carrito
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar los ítems del carrito
class CartLoadRequested extends CartEvent {
  const CartLoadRequested();
}

/// Evento para cargar el carrito desde la API
class CartLoadFromApiRequested extends CartEvent {
  const CartLoadFromApiRequested();
}

/// Evento para añadir un ítem al carrito
class CartItemAdded extends CartEvent {
  /// El producto a añadir
  final ProductItemModel product;

  /// La talla seleccionada
  final String size;

  /// El color seleccionado
  final ProductColorOption color;

  /// La cantidad a añadir
  final int quantity;

  const CartItemAdded({
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
  });

  @override
  List<Object> get props => [product, size, color, quantity];
}

/// Evento para añadir un ítem al carrito usando la API
class CartItemAddedToApi extends CartEvent {
  /// ID de la variante del producto
  final String productVariantId;

  /// La cantidad a añadir
  final int quantity;

  const CartItemAddedToApi({
    required this.productVariantId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productVariantId, quantity];
}

/// Evento para eliminar un ítem del carrito
class CartItemRemoved extends CartEvent {
  /// Id del ítem a eliminar
  final String itemId;

  const CartItemRemoved({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

/// Evento para eliminar un ítem del carrito usando la API
class CartItemRemovedFromApi extends CartEvent {
  /// Id del ítem a eliminar en la API
  final String apiItemId;

  const CartItemRemovedFromApi({required this.apiItemId});

  @override
  List<Object> get props => [apiItemId];
}

/// Evento para actualizar la cantidad de un ítem
class CartItemQuantityUpdated extends CartEvent {
  /// Id del ítem a actualizar
  final String itemId;

  /// Nueva cantidad
  final int newQuantity;

  const CartItemQuantityUpdated({
    required this.itemId,
    required this.newQuantity,
  });

  @override
  List<Object> get props => [itemId, newQuantity];
}

/// Evento para actualizar la cantidad de un ítem usando la API
class CartItemQuantityUpdatedInApi extends CartEvent {
  /// Id del ítem a actualizar en la API
  final String apiItemId;

  /// Nueva cantidad
  final int newQuantity;

  const CartItemQuantityUpdatedInApi({
    required this.apiItemId,
    required this.newQuantity,
  });

  @override
  List<Object> get props => [apiItemId, newQuantity];
}

/// Evento para vaciar el carrito
class CartCleared extends CartEvent {
  const CartCleared();
}

/// Evento para vaciar el carrito usando la API
class CartClearedFromApi extends CartEvent {
  const CartClearedFromApi();
}
