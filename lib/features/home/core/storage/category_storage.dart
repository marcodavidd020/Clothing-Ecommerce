import 'dart:convert';
import 'package:flutter_application_ecommerce/core/storage/storage_service.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Clase para manejar la persistencia de datos relacionados con categorías
class CategoryStorage {
  /// Instancia del servicio de almacenamiento
  final StorageService _storageService;
  
  /// Clave para almacenar la categoría seleccionada
  static const String _selectedCategoryKey = 'selected_category';
  
  /// Constructor
  CategoryStorage(this._storageService);
  
  /// Guarda la categoría seleccionada
  Future<bool> saveSelectedCategory(CategoryApiModel category) async {
    try {
      // Convertir la categoría a un mapa simplificado para persistir solo los datos esenciales
      final Map<String, dynamic> categoryMap = {
        'id': category.id,
        'name': category.name,
        'slug': category.slug,
        'image': category.image,
        'parent_id': category.parentId,
        'hasChildren': category.hasChildren,
        // No guardamos children ni products para evitar datos excesivos
      };
      
      final String categoryJson = jsonEncode(categoryMap);
      return await _storageService.setString(_selectedCategoryKey, categoryJson);
    } catch (e) {
      // Si ocurre un error, devolver falso
      return false;
    }
  }
  
  /// Obtiene la categoría seleccionada
  /// 
  /// Retorna null si no hay categoría guardada o si ocurre un error
  Future<CategoryApiModel?> getSelectedCategory() async {
    try {
      final String? categoryJson = await _storageService.getString(_selectedCategoryKey);
      
      if (categoryJson == null || categoryJson.isEmpty) {
        return null;
      }
      
      // Convertir el String JSON a un mapa y luego a un modelo de categoría
      final Map<String, dynamic> categoryMap = jsonDecode(categoryJson);
      return CategoryApiModel.fromJson(categoryMap);
    } catch (e) {
      // Si ocurre un error, devolver null
      return null;
    }
  }
  
  /// Obtiene el ID de la categoría seleccionada
  /// 
  /// Útil cuando solo necesitamos el ID para cargar la categoría completa
  Future<String?> getSelectedCategoryId() async {
    try {
      final String? categoryJson = await _storageService.getString(_selectedCategoryKey);
      
      if (categoryJson == null || categoryJson.isEmpty) {
        return null;
      }
      
      final Map<String, dynamic> categoryMap = jsonDecode(categoryJson);
      return categoryMap['id'] as String?;
    } catch (e) {
      return null;
    }
  }
  
  /// Elimina la categoría seleccionada
  Future<bool> clearSelectedCategory() async {
    return await _storageService.remove(_selectedCategoryKey);
  }
} 