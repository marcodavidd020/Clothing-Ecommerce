import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_api_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Implementación del repositorio para la pantalla de inicio
class HomeRepositoryImpl implements HomeRepository {
  final ProductDataSource _productDataSource;
  final CategoryApiDataSource? _categoryApiDataSource;

  HomeRepositoryImpl({
    required ProductDataSource productDataSource,
    required CategoryApiDataSource? categoryApiDataSource,
  }) : _productDataSource = productDataSource,
       _categoryApiDataSource = categoryApiDataSource;

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
}
