import 'package:flutter_application_ecommerce/features/product_detail/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/helpers/helpers.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final CartBloc? cartBloc;
  final ProductDetailModel? productDetail;

  ProductDetailBloc({
    this.cartBloc,
    this.productDetail,
  }) : super(ProductDetailInitial()) {
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
  ) async {
    if (state is ProductDetailLoaded && event.context != null) {
      final currentState = state as ProductDetailLoaded;
      final product = currentState.product;
      final size = currentState.selectedSize;
      final color = currentState.selectedColor;
      final quantity = currentState.quantity;

      // Verificar si se puede añadir al carrito
      if (!CartIntegrationHelper.canAddToCart(
        productDetail: productDetail,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
      )) {
        if (event.context != null) {
          CartIntegrationHelper.showAddToCartSnackBar(
            context: event.context!,
            success: false,
            productName: product.name,
            quantity: quantity,
          );
        }
        return;
      }

      // Añadir al carrito usando el helper de integración
      final success = await CartIntegrationHelper.addProductToCart(
        context: event.context!,
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
        productDetail: productDetail,
      );

      // Mostrar resultado
      if (event.context != null) {
        CartIntegrationHelper.showAddToCartSnackBar(
          context: event.context!,
          success: success,
          productName: product.name,
          quantity: quantity,
        );
      }
    }
  }
}
