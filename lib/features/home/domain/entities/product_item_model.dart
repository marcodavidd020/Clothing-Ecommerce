// import 'package:flutter/material.dart'; // Necesario para Color
import 'product_color_option_model.dart';

class ProductItemModel {
  final String id;
  final String imageUrl; // Imagen principal
  final List<String> additionalImageUrls; // Lista de URLs para imágenes adicionales
  final String name;
  final double price;
  final double? originalPrice;
  final bool isFavorite;
  final double averageRating;
  final int? reviewCount;
  final String description;
  final List<String> availableSizes;
  final List<ProductColorOption> availableColors;

  ProductItemModel({
    required this.id,
    required this.imageUrl,
    this.additionalImageUrls = const [],
    required this.name,
    required this.price,
    this.originalPrice,
    this.isFavorite = false,
    this.averageRating = 0.0,
    this.reviewCount,
    this.description = 'N/A',
    this.availableSizes = const [],
    this.availableColors = const [],
  });
  
  @override
  String toString() {
    return 'ProductItemModel{id: $id, name: $name, price: $price}';
  }
}
