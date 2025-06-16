class CreateOrderRequestModel {
  final String addressId;
  final String paymentMethod;
  final List<OrderItemCreateModel> items;
  final String? couponCode;

  CreateOrderRequestModel({
    required this.addressId,
    required this.paymentMethod,
    required this.items,
    this.couponCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'payment_method': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      if (couponCode != null) 'coupon_code': couponCode,
    };
  }
}

class OrderItemCreateModel {
  final String productVariantId;
  final int quantity;

  OrderItemCreateModel({
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_variant_id': productVariantId,
      'quantity': quantity,
    };
  }
} 