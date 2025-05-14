import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/category_model.dart';

/// Define los métodos para acceder a los datos de las categorías
abstract class CategoryDataSource {
  /// Obtiene una lista de categorías
  Future<List<CategoryModel>> getCategories();
}

/// Implementación que carga las categorías desde un archivo JSON local
class CategoryLocalDataSource implements CategoryDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Carga el archivo JSON desde los assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/categories.json',
      );

      // Decodifica el JSON a un mapa
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Obtiene la lista de categorías y las convierte a objetos CategoryModel
      final categoriesList =
          (jsonMap['categories'] as List<dynamic>)
              .map(
                (categoryJson) => CategoryModel.fromJson(
                  categoryJson as Map<String, dynamic>,
                ),
              )
              .toList();

      return categoriesList;
    } catch (e) {
      throw CacheException(
        // message: 'Error al cargar las categorías: ${e.toString()}',
      );
    }
  }
}
