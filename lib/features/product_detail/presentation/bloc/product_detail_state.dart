part of 'product_detail_bloc.dart';

// import 'package:equatable/equatable.dart'; // Ya no es necesario aquí, está en el bloc

abstract class ProductDetailState extends Equatable {
  // Reactivar Equatable
  const ProductDetailState();

  @override // Reactivar override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductItemModel product;
  final String selectedSize;
  final ProductColorOption selectedColor;
  final int quantity;
  final bool isFavorite; // Podríamos añadir más adelante lógica para esto

  const ProductDetailLoaded({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.isFavorite,
  });

  // Método copyWith para facilitar la actualización del estado
  ProductDetailLoaded copyWith({
    ProductItemModel? product,
    String? selectedSize,
    ProductColorOption? selectedColor,
    int? quantity,
    bool? isFavorite,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    product,
    selectedSize,
    selectedColor,
    quantity,
    isFavorite,
  ];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
