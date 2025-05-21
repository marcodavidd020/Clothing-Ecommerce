import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Caso de uso para obtener las categorías en formato árbol desde la API
class GetApiCategoriesTreeUseCase {
  final HomeRepository _repository;

  GetApiCategoriesTreeUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener el árbol de categorías
  Future<Either<Failure, List<CategoryApiModel>>> execute() async {
    return await _repository.getApiCategoryTree();
  }
}
