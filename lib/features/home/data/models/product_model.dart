import 'package:flutter_application_ecommerce/features/home/data/models/product_color_option_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';

/// Modelo para mapear productos desde JSON
class ProductModel extends ProductItemModel {
  /// Crea una instancia de [ProductModel]
  ProductModel({
    required super.id,
    required super.imageUrl,
    super.additionalImageUrls = const [],
    required super.name,
    required super.price,
    super.originalPrice,
    super.isFavorite = false,
    super.averageRating = 0.0,
    super.reviewCount,
    super.description = 'N/A',
    super.availableSizes = const [],
    required super.availableColors,
  });

  /// Crea una instancia de [ProductModel] desde un mapa
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      additionalImageUrls: const [],
      name: json['name'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      originalPrice: json['discountPrice'] != null
          ? double.tryParse(json['discountPrice'].toString())
          : null,
      isFavorite: false,
      averageRating: 0.0,
      reviewCount: null,
      description: json['description'] as String? ?? 'N/A',
      availableSizes: const [],
      availableColors: const [],
    );
  }

  /// Convierte este modelo a un mapa
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'additionalImageUrls': additionalImageUrls,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'isFavorite': isFavorite,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'description': description,
      'availableSizes': availableSizes,
      'availableColors':
          availableColors
              .map((color) => (color as ProductColorOptionModel).toJson())
              .toList(),
    };
  }
}
