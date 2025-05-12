import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Caso de uso para obtener los productos nuevos
class GetNewInProductsUseCase {
  final HomeRepository _repository;

  GetNewInProductsUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener los productos nuevos
  Future<Either<Failure, List<ProductItemModel>>> execute() async {
    return await _repository.getNewInProducts();
  }
}
