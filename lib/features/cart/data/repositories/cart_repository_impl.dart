import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/cart/data/datasources/cart_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Implementación del repositorio para el carrito
class CartRepositoryImpl implements CartRepository {
  final CartApiDataSource _cartApiDataSource;

  CartRepositoryImpl({required CartApiDataSource cartApiDataSource})
      : _cartApiDataSource = cartApiDataSource;

  @override
  Future<Either<Failure, CartApiModel>> getMyCart() async {
    try {
      final cart = await _cartApiDataSource.getMyCart();
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartApiModel>> addItemToCart(
    String productVariantId,
    int quantity,
  ) async {
    try {
      final cart = await _cartApiDataSource.addItemToCart(
        productVariantId,
        quantity,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartApiModel>> updateCartItem(
    String itemId,
    int quantity,
  ) async {
    try {
      final cart = await _cartApiDataSource.updateCartItem(itemId, quantity);
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartApiModel>> removeCartItem(String itemId) async {
    try {
      final cart = await _cartApiDataSource.removeCartItem(itemId);
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartApiModel>> clearCart() async {
    try {
      final cart = await _cartApiDataSource.clearCart();
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 