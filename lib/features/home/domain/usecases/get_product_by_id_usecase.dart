import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';

/// Caso de uso para obtener los detalles de un producto por su ID
class GetProductByIdUseCase {
  final HomeRepository _repository;

  GetProductByIdUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener los detalles de un producto por su ID
  Future<Either<Failure, ProductDetailModel>> execute(String productId) async {
    return await _repository.getProductById(productId);
  }
}
