import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';

class CategoryApiModel {
  final String id;
  final String name;
  final String slug;
  final String? image;
  final List<CategoryApiModel> children;

  CategoryApiModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.children = const [],
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String?,
      children:
          json['children'] != null
              ? (json['children'] as List<dynamic>)
                  .map(
                    (child) => CategoryApiModel.fromJson(
                      child as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : [],
    );
  }

  // Método para convertir a CategoryItemModel para mantener compatibilidad
  CategoryItemModel toCategoryItemModel() {
    return CategoryItemModel(imageUrl: image ?? '', name: name);
  }

  // Método para obtener todas las categorías (incluidas subcategorías) como lista plana
  List<CategoryApiModel> getAllCategories() {
    final result = <CategoryApiModel>[this];
    for (final child in children) {
      result.addAll(child.getAllCategories());
    }
    return result;
  }

  // Método para depuración
  @override
  String toString() {
    return 'CategoryApiModel(id: $id, name: $name, children: ${children.length})';
  }
}
