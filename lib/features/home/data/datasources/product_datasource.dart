import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_model.dart';

/// Define los métodos para acceder a los datos de los productos
abstract class ProductDataSource {
  /// Obtiene los productos más vendidos
  Future<List<ProductModel>> getTopSellingProducts();

  /// Obtiene los productos nuevos
  Future<List<ProductModel>> getNewInProducts();

  /// Obtiene productos por categoría (simulación)
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
}

/// Implementación que carga los productos desde archivos JSON locales
class ProductLocalDataSource implements ProductDataSource {
  @override
  Future<List<ProductModel>> getTopSellingProducts() async {
    try {
      // Carga el archivo JSON desde los assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/top_selling_products.json',
      );

      // Decodifica el JSON a un mapa
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Obtiene la lista de productos y las convierte a objetos ProductModel
      final productsList =
          (jsonMap['topSellingProducts'] as List<dynamic>)
              .map(
                (productJson) =>
                    ProductModel.fromJson(productJson as Map<String, dynamic>),
              )
              .toList();

      return productsList;
    } catch (e) {
      throw CacheException(
        message: 'Error al cargar los productos más vendidos: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ProductModel>> getNewInProducts() async {
    try {
      // Carga el archivo JSON desde los assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/new_in_products.json',
      );

      // Decodifica el JSON a un mapa
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Obtiene la lista de productos y las convierte a objetos ProductModel
      final productsList =
          (jsonMap['newInProducts'] as List<dynamic>)
              .map(
                (productJson) =>
                    ProductModel.fromJson(productJson as Map<String, dynamic>),
              )
              .toList();

      return productsList;
    } catch (e) {
      throw CacheException(
        message: 'Error al cargar los productos nuevos: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      // En una implementación real, aquí se cargarían productos específicos por categoría
      // Como es una simulación, usamos los productos más vendidos o nuevos según el ID

      // Si el ID de categoría termina en un número par, usamos los más vendidos
      if (categoryId.codeUnitAt(categoryId.length - 1) % 2 == 0) {
        return await getTopSellingProducts();
      } else {
        // Si es impar, usamos los nuevos
        return await getNewInProducts();
      }
    } catch (e) {
      throw CacheException(
        message: 'Error al cargar productos por categoría: ${e.toString()}',
      );
    }
  }
}
