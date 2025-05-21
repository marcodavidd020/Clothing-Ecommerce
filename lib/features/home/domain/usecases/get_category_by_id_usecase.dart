import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Caso de uso para obtener una categoría específica por su ID
class GetCategoryByIdUseCase {
  final HomeRepository _repository;

  GetCategoryByIdUseCase(this._repository);

  /// Ejecuta el caso de uso para obtener una categoría por ID
  Future<Either<Failure, CategoryApiModel>> execute(String id) async {
    return await _repository.getCategoryById(id);
  }
} 