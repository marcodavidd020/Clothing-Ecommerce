import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

class CategoryApiModel {
  /// Identificador único de la categoría
  final String id;

  /// Nombre de la categoría
  final String name;

  /// Slug de la categoría para URLs
  final String slug;

  /// Imagen de la categoría (URL)
  final String? image;

  /// Identificador de la categoría padre (null si es raíz)
  final String? parentId;

  /// Subcategorías hijas
  final List<CategoryApiModel> children;

  /// Indica si esta categoría tiene subcategorías
  final bool hasChildren;

  /// Productos asociados directamente a esta categoría
  final List<ProductItemModel> products;

  /// Constructor
  const CategoryApiModel({
    required this.id,
    required this.name,
    this.slug = '',
    this.image,
    this.parentId,
    this.children = const [],
    this.hasChildren = false,
    this.products = const [],
  });

  /// Crea una copia de este objeto con los valores provistos
  CategoryApiModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? image,
    String? parentId,
    List<CategoryApiModel>? children,
    bool? hasChildren,
    List<ProductItemModel>? products,
  }) {
    return CategoryApiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      image: image ?? this.image,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
      hasChildren: hasChildren ?? this.hasChildren,
      products: products ?? this.products,
    );
  }

  /// Obtiene la ruta completa de esta categoría (para breadcrumbs)
  List<CategoryApiModel> getPathFromRoot(List<CategoryApiModel> allCategories) {
    final path = <CategoryApiModel>[this];

    var currentParentId = parentId;
    while (currentParentId != null) {
      final parent = allCategories.firstWhere(
        (category) => category.id == currentParentId,
        orElse: () => this,
      );

      if (parent.id == id) break; // Evitar ciclos infinitos

      path.insert(0, parent);
      currentParentId = parent.parentId;
    }

    return path;
  }

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
      parentId: json['parent_id'] as String?,
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
      hasChildren: json['hasChildren'] as bool? ?? false,
      products:
          json['products'] != null
              ? (json['products'] as List<dynamic>).map((product) {
                // Convertir precios de string a double
                final priceStr = product['price'] as String? ?? '0';
                final discountPriceStr = product['discountPrice'] as String?;

                final price = double.tryParse(priceStr) ?? 0.0;
                final discountPrice =
                    discountPriceStr != null
                        ? double.tryParse(discountPriceStr)
                        : null;

                return ProductItemModel(
                  id: product['id'] as String,
                  imageUrl: product['image'] as String,
                  name: product['name'] as String,
                  price:
                      discountPrice ??
                      price, // Si hay precio de descuento, ese es el precio actual
                  originalPrice:
                      discountPrice != null
                          ? price
                          : null, // El precio original solo si hay descuento
                  isFavorite: false, // No viene del API, inicializar en false
                  description: product['description'] as String? ?? '',
                );
              }).toList()
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

  /// Compatibilidad hacia atrás para código que use subCategories
  List<CategoryApiModel> get subCategories => children;

  /// Compatibilidad hacia atrás para código que use imageUrl
  String? get imageUrl => image;

  /// Compatibilidad hacia atrás para código que use hasProducts
  bool get hasProducts => products.isNotEmpty;

  /// Compatibilidad hacia atrás para código que use productCount
  int? get productCount => products.isNotEmpty ? products.length : null;

  /// Compatibilidad hacia atrás para verificar si tiene subcategorías
  bool get hasSubCategories => children.isNotEmpty;

  // Método para depuración
  @override
  String toString() {
    return 'CategoryApiModel(id: $id, name: $name, children: ${children.length}, products: ${products.length})';
  }
}
