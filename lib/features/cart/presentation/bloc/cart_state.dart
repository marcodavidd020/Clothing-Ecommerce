import 'package:equatable/equatable.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';

/// Estados posibles para el BLoC del carrito
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

/// Estado inicial del carrito, antes de cargar información
class CartInitial extends CartState {
  const CartInitial();
}

/// Estado de carga del carrito
class CartLoading extends CartState {
  const CartLoading();
}

/// Estado cuando el carrito se ha cargado correctamente
class CartLoaded extends CartState {
  /// Lista de ítems en el carrito
  final List<CartItemModel> items;

  /// Total de ítems en el carrito (sumando cantidades)
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Precio total del carrito
  double get totalPrice => items.fold(0, (sum, item) => sum + item.total);

  /// Verifica si el carrito está vacío
  bool get isEmpty => items.isEmpty;

  const CartLoaded({this.items = const []});

  @override
  List<Object> get props => [items];

  /// Crea una copia del estado con algunos campos modificados
  CartLoaded copyWith({List<CartItemModel>? items}) {
    return CartLoaded(items: items ?? this.items);
  }
}

/// Estado de error al cargar o manipular el carrito
class CartError extends CartState {
  /// Mensaje de error
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
