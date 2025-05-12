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

/// Evento para eliminar un ítem del carrito
class CartItemRemoved extends CartEvent {
  /// Id del ítem a eliminar
  final String itemId;

  const CartItemRemoved({required this.itemId});

  @override
  List<Object> get props => [itemId];
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

/// Evento para vaciar el carrito
class CartCleared extends CartEvent {
  const CartCleared();
}
