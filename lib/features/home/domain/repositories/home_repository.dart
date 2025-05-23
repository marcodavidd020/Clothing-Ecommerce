import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';

/// Repositorio para obtener los datos de la pantalla de inicio
abstract class HomeRepository {
  /// Obtiene las categorías desde la API (formato plano)
  Future<Either<Failure, List<CategoryApiModel>>> getApiCategories();

  /// Obtiene las categorías desde la API (formato árbol)
  Future<Either<Failure, List<CategoryApiModel>>> getApiCategoryTree();

  /// Obtiene una categoría específica por su ID
  Future<Either<Failure, CategoryApiModel>> getCategoryById(String id);

  /// Obtiene productos por categoría
  Future<Either<Failure, List<ProductItemModel>>> getProductsByCategory(
    String categoryId,
  );

  /// Obtiene detalles de un producto específico por su ID
  Future<Either<Failure, ProductDetailModel>> getProductById(String id);

  /// Obtiene los productos más vendidos
  Future<Either<Failure, List<ProductDetailModel>>> getProductsBestSellers(
    String categoryId,
  );

  /// Obtiene los productos más nuevos
  Future<Either<Failure, List<ProductDetailModel>>> getProductsNewest(
    String categoryId,
  );
}
