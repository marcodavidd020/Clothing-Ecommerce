import 'package:dartz/dartz.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/error/failures.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Implementación del repositorio para la pantalla de inicio
class HomeRepositoryImpl implements HomeRepository {
  final CategoryDataSource _categoryDataSource;
  final ProductDataSource _productDataSource;

  HomeRepositoryImpl({
    required CategoryDataSource categoryDataSource,
    required ProductDataSource productDataSource,
  })  : _categoryDataSource = categoryDataSource,
        _productDataSource = productDataSource;

  @override
  Future<Either<Failure, List<CategoryItemModel>>> getCategories() async {
    try {
      final categories = await _categoryDataSource.getCategories();
      return Right(categories);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Error al cargar las categorías'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductItemModel>>> getTopSellingProducts() async {
    try {
      final products = await _productDataSource.getTopSellingProducts();
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Error al cargar los productos más vendidos'));
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
      return Left(CacheFailure(message: e.message ?? 'Error al cargar los productos nuevos'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductItemModel>>> getProductsByCategory(
      String categoryId) async {
    try {
      final products = await _productDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Error al cargar los productos por categoría'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 