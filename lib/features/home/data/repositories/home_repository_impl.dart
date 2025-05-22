import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Implementación del repositorio para la pantalla de inicio
class HomeRepositoryImpl implements HomeRepository {
  final CategoryApiDataSource? _categoryApiDataSource;
  final ProductApiDataSource? _productApiDataSource;

  HomeRepositoryImpl({
    required CategoryApiDataSource? categoryApiDataSource,
    ProductApiDataSource? productApiDataSource,
  }) : _categoryApiDataSource = categoryApiDataSource,
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
      } on ServerException catch (e) {
        // Si falla la API, retornar el error con el mensaje específico
        return Left(
          ServerFailure(message: e.message),
        );
      } catch (e) {
        // Si ocurre otro error, retornar el error con su mensaje
        return Left(UnknownFailure(message: e.toString()));
      }
    }
    // Si no hay API datasource, devolver un fallo.
    return Left(ServerFailure(message: 'API ProductDataSource no disponible'));
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
