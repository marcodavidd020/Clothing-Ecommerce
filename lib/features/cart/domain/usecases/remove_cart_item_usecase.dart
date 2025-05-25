import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para eliminar un item del carrito
class RemoveCartItemUseCase {
  final CartRepository _cartRepository;

  RemoveCartItemUseCase(this._cartRepository);

  /// Ejecuta el caso de uso para eliminar un item del carrito
  Future<Either<Failure, CartApiModel>> execute(String itemId) async {
    return await _cartRepository.removeCartItem(itemId);
  }
} 