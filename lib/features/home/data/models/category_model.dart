import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';

/// Modelo para mapear categorías desde JSON
class CategoryModel extends CategoryItemModel {
  /// Crea una instancia de [CategoryModel]
  CategoryModel({required String imageUrl, required String name})
    : super(imageUrl: imageUrl, name: name);

  /// Crea una instancia de [CategoryModel] desde un mapa
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
    );
  }

  /// Convierte este modelo a un mapa
  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl, 'name': name};
  }
}
