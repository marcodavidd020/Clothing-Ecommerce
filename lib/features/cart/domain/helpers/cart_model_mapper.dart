import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/cart/data/models/cart_api_model.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/entities/cart_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';

/// Helper para convertir entre modelos de la API y modelos de dominio
class CartModelMapper {
  /// Convierte una lista de items de la API a modelos de dominio
  static List<CartItemModel> fromApiItems(List<CartItemApiModel> apiItems) {
    return apiItems.map((apiItem) => fromApiItem(apiItem)).toList();
  }

  /// Convierte un item de la API a modelo de dominio
  static CartItemModel fromApiItem(CartItemApiModel apiItem) {
    final product = _convertToProductItemModel(apiItem.productVariant.product);
    final color = _convertToProductColorOption(apiItem.productVariant.color);

    // Log para debugging
    print('🔍 CART MAPPER DEBUG:');
    print('  - Product: ${apiItem.productVariant.product.name}');
    print('  - Cart Item ID: ${apiItem.id}');
    print('  - Product Variant ID: ${apiItem.productVariantId}');
    print('  - Variant from object: ${apiItem.productVariant.id}');
    print('  - Color: ${apiItem.productVariant.color}');
    print('  - Size: ${apiItem.productVariant.size}');

    return CartItemModel(
      product: product,
      size: apiItem.productVariant.size ?? 'N/A',
      color: color,
      quantity: apiItem.quantity,
      apiItemId: apiItem.productVariantId, // CORREGIDO: Usar productVariantId en lugar de item.id
    );
  }

  /// Convierte el producto de la API a ProductItemModel
  static ProductItemModel _convertToProductItemModel(ProductApiModel apiProduct) {
    return ProductItemModel(
      id: apiProduct.id,
      imageUrl: apiProduct.image,
      name: apiProduct.name,
      price: apiProduct.price,
      originalPrice: apiProduct.discountPrice,
      description: apiProduct.description,
      availableSizes: const [], // No tenemos esta información en la API del carrito
      availableColors: const [], // No tenemos esta información en la API del carrito
    );
  }

  /// Convierte el color de string a ProductColorOption
  static ProductColorOption _convertToProductColorOption(String? colorName) {
    if (colorName == null) {
      return ProductColorOption(name: 'N/A', color: Colors.grey);
    }

    // Mapeo básico de nombres de colores a objetos Color
    final colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'purple': Colors.purple,
      'orange': Colors.orange,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'black': Colors.black,
      'white': Colors.white,
      'gray': Colors.grey,
      'grey': Colors.grey,
    };

    final color = colorMap[colorName.toLowerCase()] ?? Colors.grey;

    return ProductColorOption(
      name: colorName,
      color: color,
    );
  }

  /// Calcula el total del carrito desde los items de la API
  static double calculateCartTotal(List<CartItemApiModel> apiItems) {
    return apiItems.fold(0.0, (total, item) {
      final price = item.productVariant.product.discountPrice ?? 
                   item.productVariant.product.price;
      return total + (price * item.quantity);
    });
  }

  /// Busca el ID de variante de producto basado en talla y color seleccionados
  /// 
  /// Parámetros:
  /// - [productDetail]: El modelo detallado del producto con sus variantes
  /// - [selectedSize]: La talla seleccionada por el usuario
  /// - [selectedColor]: El color seleccionado por el usuario
  /// 
  /// Retorna el ID de la variante que coincida con la talla y color, o null si no se encuentra
  static String? findProductVariantId(
    ProductDetailModel productDetail,
    String selectedSize,
    ProductColorOption selectedColor,
  ) {
    try {
      // Buscar en las variantes del producto
      final matchingVariant = productDetail.variants.firstWhere(
        (variant) =>
            variant.size?.toLowerCase() == selectedSize.toLowerCase() &&
            variant.color?.toLowerCase() == selectedColor.name.toLowerCase(),
      );
      
      return matchingVariant.id;
    } catch (e) {
      // Si no se encuentra una variante exacta, retornar null
      return null;
    }
  }

  /// Busca el primer ID de variante disponible para un producto
  /// 
  /// Útil como fallback cuando no se puede encontrar una variante específica
  static String? findFirstAvailableVariantId(ProductDetailModel productDetail) {
    if (productDetail.variants.isEmpty) return null;
    
    // Buscar la primera variante con stock disponible
    for (final variant in productDetail.variants) {
      if (variant.stock > 0) {
        return variant.id;
      }
    }
    
    // Si no hay variantes con stock, retornar la primera disponible
    return productDetail.variants.first.id;
  }

  /// Verifica si una variante específica está disponible en stock
  static bool isVariantAvailable(
    ProductDetailModel productDetail,
    String selectedSize,
    ProductColorOption selectedColor,
  ) {
    try {
      final matchingVariant = productDetail.variants.firstWhere(
        (variant) =>
            variant.size?.toLowerCase() == selectedSize.toLowerCase() &&
            variant.color?.toLowerCase() == selectedColor.name.toLowerCase(),
      );
      
      return matchingVariant.stock > 0;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene el stock disponible para una variante específica
  static int getVariantStock(
    ProductDetailModel productDetail,
    String selectedSize,
    ProductColorOption selectedColor,
  ) {
    try {
      final matchingVariant = productDetail.variants.firstWhere(
        (variant) =>
            variant.size?.toLowerCase() == selectedSize.toLowerCase() &&
            variant.color?.toLowerCase() == selectedColor.name.toLowerCase(),
      );
      
      return matchingVariant.stock;
    } catch (e) {
      return 0;
    }
  }

  /// Extrae un ID de variante de producto desde un CartItemModel existente
  /// Esto es útil cuando necesitamos hacer operaciones API con items existentes
  static String? extractProductVariantId(CartItemModel domainItem) {
    // Nota: En un escenario real, necesitaríamos almacenar el ID de variante
    // en el modelo de dominio o tener una forma de obtenerlo.
    // Por ahora, retornamos null ya que no tenemos esa información.
    return null;
  }
} 