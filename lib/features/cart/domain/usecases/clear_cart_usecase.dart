import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para vaciar completamente el carrito
class ClearCartUseCase {
  final CartRepository _cartRepository;

  ClearCartUseCase(this._cartRepository);

  /// Ejecuta el caso de uso para vaciar el carrito
  Future<Either<Failure, CartApiModel>> execute() async {
    return await _cartRepository.clearCart();
  }
} 