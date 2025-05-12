import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_color_option_model.dart';

/// Modelo para mapear opciones de color del producto desde JSON
class ProductColorOptionModel extends ProductColorOption {
  /// Crea una instancia de [ProductColorOptionModel]
  ProductColorOptionModel({
    required String name,
    required Color color,
  }) : super(
          name: name,
          color: color,
        );

  /// Crea una instancia de [ProductColorOptionModel] desde un mapa
  factory ProductColorOptionModel.fromJson(Map<String, dynamic> json) {
    // Convertir el código de color hexadecimal a un objeto Color
    Color getColorFromHex(String hexColor) {
      // Si el hexColor comienza con #, eliminar el #
      final String colorStr = hexColor.startsWith('#') ? hexColor.substring(1) : hexColor;
      // Convertir el string hexadecimal a un int
      try {
        return Color(int.parse('0xFF$colorStr'));
      } catch (e) {
        // En caso de error, retornar un color por defecto
        return Colors.grey;
      }
    }

    // Obtener el nombre del color o un valor predeterminado
    final String name = json['name'] as String? ?? 'Default';
    
    // Verificar si tenemos colorCode o color en el json
    String? colorValue;
    if (json['colorCode'] != null) {
      colorValue = json['colorCode'] as String;
    } else if (json['color'] != null) {
      colorValue = json['color'] as String;
    } else {
      // Si no hay información de color, usar gris
      return ProductColorOptionModel(name: name, color: Colors.grey);
    }

    return ProductColorOptionModel(
      name: name,
      color: getColorFromHex(colorValue),
    );
  }

  /// Convierte este modelo a un mapa
  Map<String, dynamic> toJson() {
    // Convertir el color a una representación hexadecimal
    String colorToHex(Color color) {
      return '#${color.value.toRadixString(16).substring(2)}';
    }
    
    return {
      'name': name,
      'colorCode': colorToHex(color),
    };
  }
} 