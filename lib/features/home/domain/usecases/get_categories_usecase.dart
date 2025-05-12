import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Caso de uso para obtener las categorías
class GetCategoriesUseCase {
  final HomeRepository _repository;

  GetCategoriesUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener las categorías
  Future<Either<Failure, List<CategoryItemModel>>> execute() async {
    return await _repository.getCategories();
  }
}
