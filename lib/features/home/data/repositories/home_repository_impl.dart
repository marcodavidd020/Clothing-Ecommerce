import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Implementación del repositorio para la pantalla de inicio
class HomeRepositoryImpl implements HomeRepository {
  final ProductDataSource _productDataSource;
  final CategoryApiDataSource? _categoryApiDataSource;
  final ProductApiDataSource? _productApiDataSource;

  HomeRepositoryImpl({
    required ProductDataSource productDataSource,
    required CategoryApiDataSource? categoryApiDataSource,
    ProductApiDataSource? productApiDataSource,
  }) : _productDataSource = productDataSource,
       _categoryApiDataSource = categoryApiDataSource,
       _productApiDataSource = productApiDataSource;

  @override
  Future<Either<Failure, List<CategoryApiModel>>> getApiCategories() async {
    if (_categoryApiDataSource == null) {
      return Left(ServerFailure(message: 'API DataSource no disponible'));
    }

    try {
      final categories = await _categoryApiDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryApiModel>>> getApiCategoryTree() async {
    if (_categoryApiDataSource == null) {
      return Left(ServerFailure(message: 'API DataSource no disponible'));
    }

    try {
      final categories = await _categoryApiDataSource.getCategoryTree();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryApiModel>> getCategoryById(String id) async {
    if (_categoryApiDataSource == null) {
      return Left(ServerFailure(message: 'API DataSource no disponible'));
    }

    try {
      final category = await _categoryApiDataSource.getCategoryById(id);
      return Right(category);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductItemModel>>>
  getTopSellingProducts() async {
    try {
      final products = await _productDataSource.getTopSellingProducts();
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductItemModel>>> getNewInProducts() async {
    try {
      final products = await _productDataSource.getNewInProducts();
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductItemModel>>> getProductsByCategory(
    String categoryId,
  ) async {
    // Si el API datasource está disponible, intentar obtener de la API primero
    if (_productApiDataSource != null) {
      try {
        final products = await _productApiDataSource.getProductsByCategory(
          categoryId,
        );
        return Right(products);
      } on ServerException catch (_) {
        // Si falla la API, intentamos con datos locales
        return _getProductsByCategoryFromLocal(categoryId);
      } catch (e) {
        // Si ocurre otro error, intentamos con datos locales
        return _getProductsByCategoryFromLocal(categoryId);
      }
    }

    // Si no hay API datasource, usar datos locales
    return _getProductsByCategoryFromLocal(categoryId);
  }

  /// Método auxiliar para obtener productos por categoría desde datos locales
  Future<Either<Failure, List<ProductItemModel>>>
  _getProductsByCategoryFromLocal(String categoryId) async {
    try {
      final products = await _productDataSource.getProductsByCategory(
        categoryId,
      );
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductDetailModel>> getProductById(String id) async {
    if (_productApiDataSource == null) {
      return Left(
        ServerFailure(message: 'API ProductDataSource no disponible'),
      );
    }

    try {
      final product = await _productApiDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
