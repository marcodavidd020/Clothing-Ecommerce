import 'package:flutter_application_ecommerce/features/product_detail/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart'; // Corregido para usar el barrel file
import 'package:flutter/material.dart'; // Para Color
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart'; // Bloc del carrito

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final CartBloc?
  cartBloc; // Opcional para permitir tests sin dependencia del CartBloc

  ProductDetailBloc({this.cartBloc}) : super(ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onProductDetailLoadRequested);
    on<ProductDetailSizeSelected>(_onProductDetailSizeSelected);
    on<ProductDetailColorSelected>(_onProductDetailColorSelected);
    on<ProductDetailQuantityChanged>(_onProductDetailQuantityChanged);
    on<ProductAddToCartRequested>(_onProductAddToCartRequested);
  }

  void _onProductDetailLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) {
    final product = event.product;
    final initialSize =
        product.availableSizes.isNotEmpty
            ? product.availableSizes.first
            : ProductDetailStrings.notAvailableSize;
    final initialColor =
        product.availableColors.isNotEmpty
            ? product.availableColors.first
            : ProductColorOption(
              name: ProductDetailStrings.defaultColorName,
              color: Colors.grey,
            );

    emit(
      ProductDetailLoaded(
        product: product,
        selectedSize: initialSize,
        selectedColor: initialColor,
        quantity: 1,
        isFavorite: product.isFavorite, // Usar el valor inicial del producto
      ),
    );
  }

  void _onProductDetailSizeSelected(
    ProductDetailSizeSelected event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(currentState.copyWith(selectedSize: event.newSize));
    }
  }

  void _onProductDetailColorSelected(
    ProductDetailColorSelected event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(currentState.copyWith(selectedColor: event.newColor));
    }
  }

  void _onProductDetailQuantityChanged(
    ProductDetailQuantityChanged event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      if (event.newQuantity >= 1) {
        // Asegurar que la cantidad no sea menor a 1
        emit(currentState.copyWith(quantity: event.newQuantity));
      }
    }
  }

  void _onProductAddToCartRequested(
    ProductAddToCartRequested event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      final product = currentState.product;
      final size = currentState.selectedSize;
      final color = currentState.selectedColor;
      final quantity = currentState.quantity;

      if (cartBloc != null) {
        // Añadir al carrito usando CartBloc
        cartBloc!.add(
          CartItemAdded(
            product: product,
            size: size,
            color: color,
            quantity: quantity,
          ),
        );

        // Opcional: Mostrar algún estado de confirmación
        // Por ejemplo, podrías tener un estado ProductDetailAddedToCart
        // O simplemente usar un SnackBar directamente desde la UI
      }
    }
  }
}
