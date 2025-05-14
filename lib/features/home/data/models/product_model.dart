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
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      additionalImageUrls:
          (json['additionalImageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice:
          json['originalPrice'] != null
              ? (json['originalPrice'] as num).toDouble()
              : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      averageRating:
          json['averageRating'] != null
              ? (json['averageRating'] as num).toDouble()
              : 0.0,
      reviewCount: json['reviewCount'] as int?,
      description: json['description'] as String? ?? 'N/A',
      availableSizes:
          (json['availableSizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availableColors:
          (json['availableColors'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ProductColorOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
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
