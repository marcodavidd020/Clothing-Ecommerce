part of 'product_detail_bloc.dart';

// import 'package:equatable/equatable.dart'; // Ya no es necesario aquí, está en el bloc

abstract class ProductDetailEvent extends Equatable {
  // Reactivar Equatable
  const ProductDetailEvent();

  @override // Reactivar override
  List<Object?> get props => [];
}

// Evento para cargar los detalles iniciales del producto
class ProductDetailLoadRequested extends ProductDetailEvent {
  final ProductItemModel product;

  const ProductDetailLoadRequested({required this.product});

  @override
  List<Object?> get props => [product];
}

// Evento cuando se selecciona una talla
class ProductDetailSizeSelected extends ProductDetailEvent {
  final String newSize;

  const ProductDetailSizeSelected({required this.newSize});

  @override
  List<Object?> get props => [newSize];
}

// Evento cuando se selecciona un color
class ProductDetailColorSelected extends ProductDetailEvent {
  final ProductColorOption newColor;

  const ProductDetailColorSelected({required this.newColor});

  @override
  List<Object?> get props => [newColor];
}

// Evento cuando cambia la cantidad
class ProductDetailQuantityChanged extends ProductDetailEvent {
  final int newQuantity;

  const ProductDetailQuantityChanged({required this.newQuantity});

  @override
  List<Object?> get props => [newQuantity];
}

// Evento cuando se añade el producto al carrito
class ProductAddToCartRequested extends ProductDetailEvent {
  final BuildContext? context;

  const ProductAddToCartRequested({this.context});

  @override
  List<Object?> get props => [context];
}
