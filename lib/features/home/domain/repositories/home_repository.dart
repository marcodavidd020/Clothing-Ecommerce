import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

/// Repositorio para obtener los datos de la pantalla de inicio
abstract class HomeRepository {
  /// Obtiene las categorías para mostrar en la pantalla de inicio
  Future<Either<Failure, List<CategoryItemModel>>> getCategories();

  /// Obtiene los productos más vendidos
  Future<Either<Failure, List<ProductItemModel>>> getTopSellingProducts();

  /// Obtiene los productos nuevos
  Future<Either<Failure, List<ProductItemModel>>> getNewInProducts();

  /// Obtiene productos por categoría
  Future<Either<Failure, List<ProductItemModel>>> getProductsByCategory(
    String categoryId,
  );
}
