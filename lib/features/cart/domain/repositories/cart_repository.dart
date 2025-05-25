import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';

/// Repositorio abstracto para operaciones del carrito
abstract class CartRepository {
  /// Obtiene el carrito del usuario actual
  Future<Either<Failure, CartApiModel>> getMyCart();

  /// Añade un item al carrito
  Future<Either<Failure, CartApiModel>> addItemToCart(
    String productVariantId,
    int quantity,
  );

  /// Actualiza la cantidad de un item en el carrito
  Future<Either<Failure, CartApiModel>> updateCartItem(
    String itemId,
    int quantity,
  );

  /// Elimina un item del carrito
  Future<Either<Failure, CartApiModel>> removeCartItem(String itemId);

  /// Vacía el carrito completamente
  Future<Either<Failure, CartApiModel>> clearCart();
} 