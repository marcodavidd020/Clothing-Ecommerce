import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/error/exceptions.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/core/network/response_handler.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_color_option_model.dart';

/// Define los métodos para acceder a los datos de los productos desde la API
abstract class ProductApiDataSource {
  /// Obtiene un producto por su ID
  Future<ProductDetailModel> getProductById(String id);

  /// Obtiene productos por categoría
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
}

/// Implementación que carga los productos desde la API remota
class ProductApiRemoteDataSource implements ProductApiDataSource {
  final DioClient _dioClient;

  ProductApiRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<ProductDetailModel> getProductById(String id) async {
    try {
      AppLogger.logInfo(
        'Llamando a getProductById endpoint: ${ApiConstants.getProductByIdEndpoint(id)}',
      );
      final response = await _dioClient.get(
        ApiConstants.getProductByIdEndpoint(id),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final productData = ResponseHandler.extractData(
          response,
          (json) => ProductDetailModel.fromJson(json),
        );
        if (productData != null) {
          AppLogger.logSuccess('Producto obtenido: ${productData.name}');
          return productData;
        } else {
          AppLogger.logError(
            'ERROR: productData es null después de extractData',
          );
          throw ServerException(
            message: 'No se pudo extraer datos del producto',
            statusCode: response.statusCode,
          );
        }
      } else {
        final errorMessage = ResponseHandler.extractErrorMessage(response);
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}, mensaje=$errorMessage',
        );
        throw ServerException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      AppLogger.logError('Error al obtener producto por ID', e);
      AppLogger.logError('EXCEPTION en getProductById: ${e.toString()}');
      throw ServerException(
        message: 'Error al obtener producto: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      AppLogger.logInfo(
        'Llamando a getProductsByCategory endpoint: ${ApiConstants.getProductsByCategoryEndpoint(categoryId)}',
      );
      final response = await _dioClient.get(
        ApiConstants.getProductsByCategoryEndpoint(categoryId),
      );
      AppLogger.logInfo(
        'Respuesta recibida: statusCode=${response.statusCode}',
      );

      if (ResponseHandler.isSuccessfulResponse(response)) {
        final productsList = ResponseHandler.extractDataList<ProductModel>(
          response,
          (json) => ProductModel.fromJson(json),
        );

        if (productsList != null) {
          AppLogger.logSuccess(
            'Productos obtenidos: ${productsList.length} productos',
          );
          return productsList;
        } else {
          AppLogger.logError(
            'ERROR: productsList es null después de extractDataList',
          );
        }
      } else {
        AppLogger.logError(
          'ERROR: Respuesta no exitosa, statusCode=${response.statusCode}',
        );
      }

      throw ServerException(
        message: ResponseHandler.extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } catch (e) {
      AppLogger.logError('Error al obtener productos por categoría', e);
      AppLogger.logError('EXCEPTION en getProductsByCategory: ${e.toString()}');
      // Devolver una lista vacía en caso de error
      return [];
    }
  }
}

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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? 'N/A',
      slug: json['slug'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discountPrice:
          json['discountPrice'] != null
              ? double.tryParse(json['discountPrice'].toString())
              : null,
      stock: json['stock'] ?? 0,
      categories: categoriesList,
      variants: variantsList,
      images: imagesList,
      additionalImageUrls: additionalUrls,
      availableSizes: availableSizes.toList(),
      availableColors: colorOptions,
    );
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'],
      hasChildren: json['hasChildren'] ?? false,
    );
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
      id: json['id'] ?? '',
      color: json['color'],
      size: json['size'],
      stock: json['stock'] ?? 0,
      productId: json['productId'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
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
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      alt: json['alt'],
      productId: json['productId'] ?? '',
    );
  }
}
