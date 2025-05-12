import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/category_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/datasources/product_datasource.dart';
import 'package:flutter_application_ecommerce/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_application_ecommerce/features/home/domain/repositories/home_repository.dart';

/// Módulo para la inyección de repositorios
class RepositoryModule {
  /// Registra todos los repositorios como providers
  static List<RepositoryProvider> providers = [
    RepositoryProvider<HomeRepository>(
      create:
          (context) => HomeRepositoryImpl(
            categoryDataSource: CategoryLocalDataSource(),
            productDataSource: ProductLocalDataSource(),
          ),
    ),
    // Aquí se pueden agregar más repositorios a medida que la aplicación crezca
  ];
}
