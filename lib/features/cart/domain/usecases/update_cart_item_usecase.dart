import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para actualizar la cantidad de un item en el carrito
class UpdateCartItemUseCase {
  final CartRepository _cartRepository;

  UpdateCartItemUseCase(this._cartRepository);

  /// Ejecuta el caso de uso para actualizar un item del carrito
  Future<Either<Failure, CartApiModel>> execute(
    String itemId,
    int quantity,
  ) async {
    return await _cartRepository.updateCartItem(itemId, quantity);
  }
} 