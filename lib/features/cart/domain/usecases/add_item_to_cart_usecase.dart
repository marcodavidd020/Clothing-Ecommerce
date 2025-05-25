import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para añadir un item al carrito
class AddItemToCartUseCase {
  final CartRepository _cartRepository;

  AddItemToCartUseCase(this._cartRepository);

  /// Ejecuta el caso de uso para añadir un item al carrito
  Future<Either<Failure, CartApiModel>> execute(
    String productVariantId,
    int quantity,
  ) async {
    return await _cartRepository.addItemToCart(productVariantId, quantity);
  }
} 