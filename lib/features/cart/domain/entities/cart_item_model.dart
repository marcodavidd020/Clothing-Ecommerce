import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

/// Modelo que representa un producto en el carrito de compras
class CartItemModel {
  /// El producto seleccionado
  final ProductItemModel product;

  /// La talla seleccionada del producto
  final String size;

  /// El color seleccionado y su nombre
  final ProductColorOption color;

  /// La cantidad seleccionada del producto
  final int quantity;

  /// ID del item en la API (para operaciones de actualización/eliminación)
  /// Es null para items creados localmente
  final String? apiItemId;

  /// Identificador único del ítem del carrito (combinación de producto, talla y color)
  String get id => '${product.id}_${size}_${color.name}';

  /// Precio total del ítem (precio unitario * cantidad)
  double get total => (product.originalPrice ?? product.price) * quantity;

  const CartItemModel({
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    this.apiItemId,
  });

  /// Crea una copia del ítem con algunos campos modificados
  CartItemModel copyWith({
    ProductItemModel? product,
    String? size,
    ProductColorOption? color,
    int? quantity,
    String? apiItemId,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      apiItemId: apiItemId ?? this.apiItemId,
    );
  }
}
