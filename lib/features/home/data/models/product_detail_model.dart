import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_color_option_model.dart';

/// Modelo para detalles completos de un producto
class ProductDetailModel extends ProductModel {
  final String slug;
  final double? discountPrice;
  final int stock;
  final List<CategoryInfo> categories;
  final List<ProductVariant> variants;
  final List<ProductImage> images;

  ProductDetailModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required this.slug,
    required super.price,
    this.discountPrice,
    required this.stock,
    required this.categories,
    required this.variants,
    required this.images,
    super.isFavorite = false,
    super.averageRating = 0.0,
    super.reviewCount = 0,
    super.availableSizes = const [],
    super.availableColors = const [],
    super.additionalImageUrls = const [],
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    // Obtener colores y tallas disponibles a partir de las variantes
    final availableSizes = <String>{};
    final availableColors = <String>{};

    final variantsList =
        json['variants'] != null
            ? (json['variants'] as List)
                .map((v) => ProductVariant.fromJson(v))
                .toList()
            : <ProductVariant>[];

    for (var variant in variantsList) {
      if (variant.size != null) availableSizes.add(variant.size!);
      if (variant.color != null) availableColors.add(variant.color!);
    }

    // Convertir las imágenes adicionales
    final imagesList =
        json['images'] != null
            ? (json['images'] as List)
                .map((i) => ProductImage.fromJson(i))
                .toList()
            : <ProductImage>[];

    final additionalUrls = imagesList.map((img) => img.url).toList();

    // Convertir categorías
    final categoriesList =
        json['categories'] != null
            ? (json['categories'] as List)
                .map((c) => CategoryInfo.fromJson(c))
                .toList()
            : <CategoryInfo>[];

    // Convertir colores a ProductColorOption
    final colorOptions =
        availableColors
            .map(
              (colorName) =>
                  ProductColorOption(name: colorName, color: Colors.grey),
            )
            .toList();

    return ProductDetailModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      description: json['description'] as String? ?? 'N/A',
      slug: json['slug'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discountPrice:
          json['discountPrice'] != null
              ? double.tryParse(json['discountPrice'].toString())
              : null,
      stock: json['stock'] as int? ?? 0,
      categories: categoriesList,
      variants: variantsList,
      images: imagesList,
      additionalImageUrls: additionalUrls,
      availableSizes: availableSizes.toList(),
      availableColors: colorOptions,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> baseJson = super.toJson();

    // Agregamos los campos específicos de ProductDetailModel
    baseJson.addAll({
      'slug': slug,
      'discountPrice': discountPrice,
      'stock': stock,
      'categories': categories.map((c) => c.toJson()).toList(),
      'variants': variants.map((v) => v.toJson()).toList(),
      'images': images.map((i) => i.toJson()).toList(),
    });

    return baseJson;
  }
}

/// Información básica de categoría
class CategoryInfo {
  final String id;
  final String name;
  final String slug;
  final String? image;
  final bool hasChildren;

  CategoryInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.hasChildren = false,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
      hasChildren: json['hasChildren'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'hasChildren': hasChildren,
    };
  }
}

/// Variante de producto
class ProductVariant {
  final String id;
  final String? color;
  final String? size;
  final int stock;
  final String productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariant({
    required this.id,
    this.color,
    this.size,
    required this.stock,
    required this.productId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String? ?? '',
      color: json['color'] as String?,
      size: json['size'] as String?,
      stock: json['stock'] as int? ?? 0,
      productId: json['productId'] as String? ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'size': size,
      'stock': stock,
      'productId': productId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Imagen de producto
class ProductImage {
  final String id;
  final String url;
  final String? alt;
  final String productId;

  ProductImage({
    required this.id,
    required this.url,
    this.alt,
    required this.productId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      alt: json['alt'] as String?,
      productId: json['productId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'alt': alt, 'productId': productId};
  }
}
