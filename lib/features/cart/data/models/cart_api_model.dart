/// Modelo para el carrito obtenido desde la API
class CartApiModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final List<CartItemApiModel> items;
  final double total;

  CartApiModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] != null
        ? (json['items'] as List)
            .map((i) => CartItemApiModel.fromJson(i))
            .toList()
        : <CartItemApiModel>[];

    return CartApiModel(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      userId: json['user_id'] as String? ?? '',
      items: itemsList,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user_id': userId,
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
    };
  }
}

/// Modelo para un item del carrito desde la API
class CartItemApiModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String cartId;
  final ProductVariantApiModel productVariant;
  final String productVariantId;
  final int quantity;

  CartItemApiModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.cartId,
    required this.productVariant,
    required this.productVariantId,
    required this.quantity,
  });

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemApiModel(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      cartId: json['cart_id'] as String? ?? '',
      productVariant: ProductVariantApiModel.fromJson(
        json['productVariant'] as Map<String, dynamic>? ?? {},
      ),
      productVariantId: json['product_variant_id'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cart_id': cartId,
      'productVariant': productVariant.toJson(),
      'product_variant_id': productVariantId,
      'quantity': quantity,
    };
  }
}

/// Modelo para la variante de producto desde la API
class ProductVariantApiModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? color;
  final String? size;
  final int stock;
  final String productId;
  final ProductApiModel product;
  final bool isActive;

  ProductVariantApiModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.color,
    this.size,
    required this.stock,
    required this.productId,
    required this.product,
    required this.isActive,
  });

  factory ProductVariantApiModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantApiModel(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      color: json['color'] as String?,
      size: json['size'] as String?,
      stock: json['stock'] as int? ?? 0,
      productId: json['productId'] as String? ?? '',
      product: ProductApiModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color,
      'size': size,
      'stock': stock,
      'productId': productId,
      'product': product.toJson(),
      'isActive': isActive,
    };
  }
}

/// Modelo para el producto desde la API del carrito
class ProductApiModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String image;
  final String slug;
  final String description;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool isActive;

  ProductApiModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.image,
    required this.slug,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.isActive,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountPrice: json['discountPrice'] != null
          ? double.tryParse(json['discountPrice'].toString())
          : null,
      stock: json['stock'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'image': image,
      'slug': slug,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'stock': stock,
      'isActive': isActive,
    };
  }
} 