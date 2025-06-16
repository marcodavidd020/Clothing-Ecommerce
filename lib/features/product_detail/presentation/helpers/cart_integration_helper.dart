import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';

/// Helper para integrar la funcionalidad del carrito con el detalle del producto
class CartIntegrationHelper {
  /// Añade un producto al carrito, priorizando la API si está disponible
  static Future<bool> addProductToCart({
    required BuildContext context,
    required ProductItemModel product,
    required String selectedSize,
    required ProductColorOption selectedColor,
    required int quantity,
    ProductDetailModel? productDetail,
  }) async {
    try {
      AppLogger.logInfo('=== INICIANDO PROCESO DE AÑADIR AL CARRITO ===');
      AppLogger.logInfo('Producto: ${product.name}');
      AppLogger.logInfo('Talla: $selectedSize');
      AppLogger.logInfo('Color: ${selectedColor.name}');
      AppLogger.logInfo('Cantidad: $quantity');
      AppLogger.logInfo('ProductDetail disponible: ${productDetail != null}');
      
      final cartBloc = getExistingCartBloc(context);
      
      if (cartBloc == null) {
        AppLogger.logWarning('CartBloc no disponible para añadir al carrito');
        return false;
      }

      AppLogger.logInfo('CartBloc encontrado');
      AppLogger.logInfo('¿Tiene casos de uso API? ${cartBloc.addItemToCartUseCase != null}');
      
      // Si tenemos acceso a los casos de uso de la API y el detalle del producto
      if (cartBloc.addItemToCartUseCase != null && productDetail != null) {
        AppLogger.logInfo('🚀 USANDO MÉTODO API');
        return await _addToCartViaApi(
          cartBloc: cartBloc,
          productDetail: productDetail,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          quantity: quantity,
        );
      } else {
        AppLogger.logInfo('📱 USANDO MÉTODO LOCAL (fallback)');
        AppLogger.logInfo('Razón: addItemToCartUseCase=${cartBloc.addItemToCartUseCase != null}, productDetail=${productDetail != null}');
        // Fallback al método local
        return _addToCartLocally(
          cartBloc: cartBloc,
          product: product,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          quantity: quantity,
        );
      }
    } catch (e) {
      AppLogger.logError('Error al añadir producto al carrito: $e');
      return false;
    }
  }

  /// Añade el producto al carrito usando la API
  static Future<bool> _addToCartViaApi({
    required CartBloc cartBloc,
    required ProductDetailModel productDetail,
    required String selectedSize,
    required ProductColorOption selectedColor,
    required int quantity,
  }) async {
    try {
      AppLogger.logInfo('=== PROCESANDO VIA API ===');
      AppLogger.logInfo('ProductDetail ID: ${productDetail.id}');
      AppLogger.logInfo('Número de variantes disponibles: ${productDetail.variants.length}');
      
      // Log de todas las variantes disponibles
      for (int i = 0; i < productDetail.variants.length; i++) {
        final variant = productDetail.variants[i];
        AppLogger.logInfo('Variante $i: ID=${variant.id}, Size=${variant.size}, Color=${variant.color}, Stock=${variant.stock}');
      }
      
      // Buscar el ID de la variante del producto
      final variantId = CartModelMapper.findProductVariantId(
        productDetail,
        selectedSize,
        selectedColor,
      );

      AppLogger.logInfo('Variante encontrada: $variantId');

      if (variantId == null) {
        AppLogger.logWarning(
          'No se encontró variante para talla: $selectedSize, color: ${selectedColor.name}',
        );
        
        // Intentar con la primera variante disponible como fallback
        final fallbackVariantId = CartModelMapper.findFirstAvailableVariantId(productDetail);
        
        if (fallbackVariantId == null) {
          AppLogger.logError('No hay variantes disponibles para este producto');
          return false;
        }
        
        AppLogger.logInfo('Usando variante fallback: $fallbackVariantId');
        cartBloc.add(CartItemAddedToApi(
          productVariantId: fallbackVariantId,
          quantity: quantity,
        ));
        return true;
      }

      // Verificar disponibilidad de stock
      if (!CartModelMapper.isVariantAvailable(productDetail, selectedSize, selectedColor)) {
        AppLogger.logWarning('Variante seleccionada sin stock disponible');
        return false;
      }

      // Verificar que la cantidad no exceda el stock disponible
      final availableStock = CartModelMapper.getVariantStock(
        productDetail,
        selectedSize,
        selectedColor,
      );
      
      if (quantity > availableStock) {
        AppLogger.logWarning(
          'Cantidad solicitada ($quantity) excede stock disponible ($availableStock)',
        );
        return false;
      }

      AppLogger.logInfo(
        '✅ AÑADIENDO AL CARRITO VIA API - Variante: $variantId, Cantidad: $quantity',
      );
      
      cartBloc.add(CartItemAddedToApi(
        productVariantId: variantId,
        quantity: quantity,
      ));
      
      return true;
    } catch (e) {
      AppLogger.logError('Error al añadir via API: $e');
      return false;
    }
  }

  /// Añade el producto al carrito usando el método local
  static bool _addToCartLocally({
    required CartBloc cartBloc,
    required ProductItemModel product,
    required String selectedSize,
    required ProductColorOption selectedColor,
    required int quantity,
  }) {
    try {
      AppLogger.logInfo(
        'Añadiendo al carrito localmente - Producto: ${product.name}, Cantidad: $quantity',
      );
      
      cartBloc.add(CartItemAdded(
        product: product,
        size: selectedSize,
        color: selectedColor,
        quantity: quantity,
      ));
      
      return true;
    } catch (e) {
      AppLogger.logError('Error al añadir localmente: $e');
      return false;
    }
  }

  /// Obtiene el CartBloc existente del contexto, si existe
  static CartBloc? getExistingCartBloc(BuildContext context) {
    try {
      return context.read<CartBloc>();
    } catch (e) {
      // CartBloc no está disponible en el contexto
      return null;
    }
  }

  /// Verifica si el CartBloc tiene capacidades de API
  static bool hasApiCapabilities(CartBloc cartBloc) {
    return cartBloc.getMyCartUseCase != null &&
           cartBloc.addItemToCartUseCase != null;
  }

  /// Carga el carrito desde la API si está disponible
  static void loadCartFromApi(BuildContext context) {
    try {
      final cartBloc = getExistingCartBloc(context);
      if (cartBloc != null && hasApiCapabilities(cartBloc)) {
        cartBloc.add(const CartLoadFromApiRequested());
      }
    } catch (e) {
      AppLogger.logError('Error al cargar carrito desde API: $e');
    }
  }

  /// Muestra un SnackBar con el resultado de añadir al carrito
  static void showAddToCartSnackBar({
    required BuildContext context,
    required bool success,
    required String productName,
    int quantity = 1,
  }) {
    final message = success
        ? '✅ $productName añadido al carrito${quantity > 1 ? ' (x$quantity)' : ''}'
        : '❌ Error al añadir $productName al carrito';
    
    final backgroundColor = success ? Colors.green : Colors.red;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Valida si se puede añadir el producto al carrito
  static bool canAddToCart({
    ProductDetailModel? productDetail,
    String? selectedSize,
    ProductColorOption? selectedColor,
    int? quantity,
  }) {
    // Validaciones básicas
    if (selectedSize == null || selectedColor == null || quantity == null || quantity <= 0) {
      return false;
    }

    // Si tenemos detalle del producto, validar stock
    if (productDetail != null) {
      return CartModelMapper.isVariantAvailable(
        productDetail,
        selectedSize,
        selectedColor,
      );
    }

    // Si no tenemos detalle, permitir añadir (método local)
    return true;
  }

  /// Obtiene el stock máximo disponible para la combinación seleccionada
  static int getMaxAvailableQuantity({
    ProductDetailModel? productDetail,
    String? selectedSize,
    ProductColorOption? selectedColor,
  }) {
    if (productDetail == null || selectedSize == null || selectedColor == null) {
      return 99; // Valor por defecto si no hay restricciones
    }

    return CartModelMapper.getVariantStock(
      productDetail,
      selectedSize,
      selectedColor,
    );
  }
}
