import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Caso de uso para obtener los productos por categoría
class GetProductsByCategoryUseCase {
  final HomeRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener los productos por categoría
  Future<Either<Failure, List<ProductItemModel>>> execute(
    String categoryId,
  ) async {
    return await _repository.getProductsByCategory(categoryId);
  }
}
