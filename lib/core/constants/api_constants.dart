import 'package:flutter_application_ecommerce/core/network/logger.dart';

class ApiConstants {
  // Usamos una IP local para desarrollo - ajustar según el entorno
  static const String baseUrl = 'http://192.168.0.202:3000/api';

  // Logs para verificar que la URL se está construyendo correctamente
  static void logEndpoints() {
    AppLogger.logInfo('API URLs configuradas:');
    AppLogger.logInfo(' - Base URL: $baseUrl');
    AppLogger.logInfo(' - Categories URL: $categoriesEndpoint');
    AppLogger.logInfo(' - Categories Tree URL: $categoriesTreeEndpoint');
    AppLogger.logInfo(' - Category by ID URL (ejemplo): ${getCategoryByIdEndpoint('example-id')}');
    AppLogger.logInfo(' - Products URL: $productsEndpoint');
    AppLogger.logInfo(' - Product by ID URL (ejemplo): ${getProductByIdEndpoint('example-id')}');
    AppLogger.logInfo(' - Products by Category URL (ejemplo): ${getProductsByCategoryEndpoint('example-id')}');
  }

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerClientEndpoint = '$baseUrl/auth/register/client';
  static const String profileEndpoint = '$baseUrl/auth/profile';

  // Category endpoints
  static const String categoriesEndpoint = '$baseUrl/categories';
  static const String categoriesTreeEndpoint = '$baseUrl/categories/tree';
  static String getCategoryByIdEndpoint(String id) => '$categoriesEndpoint/$id';

  // Product endpoints
  static const String productsEndpoint = '$baseUrl/products';
  static String getProductByIdEndpoint(String id) => '$productsEndpoint/$id';
  static String getProductsByCategoryEndpoint(String categoryId) => '$productsEndpoint/by-category/$categoryId';
  static String getProductsBestSellersEndpoint(String categoryId) => '$productsEndpoint/best-sellers/by-category/$categoryId';
  static String getProductsNewestEndpoint(String categoryId) => '$productsEndpoint/newest/by-category/$categoryId';
  static String getPrdouctsBestSellersEndpoint(String categoryId) => '$productsEndpoint/best-sellers/by-category/$categoryId';
  static String getPrdouctsNewestEndpoint(String categoryId) => '$productsEndpoint/newest/by-category/$categoryId';
  static const String productsBestSellersEndpoint = '$productsEndpoint/best-sellers';
  static const String productsNewestEndpoint = '$productsEndpoint/newest';

  // Cart endpoints
  static const String cartEndpoint = '$baseUrl/carts';
  static const String cartMyCartEndpoint = '$cartEndpoint/my-cart';
  static const String cartMyCartItemsEndpoint = '$cartMyCartEndpoint/items';
  static String getCartMyCartItemEndpoint(String itemId) => '$cartMyCartItemsEndpoint/$itemId';
  static String getCartMyCartClearEndpoint() => '$cartMyCartEndpoint/clear';

  // Coupon endpoints - Actualizado para usar endpoints correctos del backend
  static const String couponsEndpoint = '$baseUrl/coupons';
  static const String userCouponsEndpoint = '$baseUrl/user-coupons';
  static const String myCouponsEndpoint = '$userCouponsEndpoint/my-coupons';
  static String getCouponByCodeEndpoint(String code) => '$couponsEndpoint/code/$code';
  static String validateCouponEndpoint(String code) => '$couponsEndpoint/validate/$code';
  static String get applyCouponEndpoint => '$couponsEndpoint/apply';
  static String removeCouponEndpoint(String couponId) => '$couponsEndpoint/$couponId/remove';

  // Payment endpoints - Actualizado según backend
  static const String paymentsEndpoint = '$baseUrl/payments';
  static String get paymentMethodsEndpoint => '$paymentsEndpoint/methods';
  static String confirmPaymentEndpoint(String paymentId) => '$paymentsEndpoint/$paymentId/confirm';
  static String cancelPaymentEndpoint(String paymentId) => '$paymentsEndpoint/$paymentId/cancel';
  static String failPaymentEndpoint(String paymentId) => '$paymentsEndpoint/$paymentId/fail';
  static String refundPaymentEndpoint(String paymentId) => '$paymentsEndpoint/$paymentId/refund';
  static String getPaymentEndpoint(String paymentId) => '$paymentsEndpoint/$paymentId';

  // Order endpoints - Actualizado según backend
  static const String ordersEndpoint = '$baseUrl/orders';
  static String get createOrderEndpoint => ordersEndpoint;
  static const String myOrdersEndpoint = '$ordersEndpoint/my-orders';
  static String getOrderEndpoint(String orderId) => '$ordersEndpoint/$orderId';
  static String getMyOrderEndpoint(String orderId) => '$myOrdersEndpoint/$orderId';
  static String cancelOrderEndpoint(String orderId) => '$ordersEndpoint/$orderId/cancel-my-order';
  static String cancelMyOrderEndpoint(String orderId) => '$ordersEndpoint/$orderId/cancel-my-order';
  static String updateOrderStatusEndpoint(String orderId) => '$ordersEndpoint/$orderId/status';

  // Address endpoints
  static const String addressesEndpoint = '$baseUrl/addresses';
  static const String myAddressesEndpoint = '$addressesEndpoint/my-addresses';
  static String getAddressEndpoint(String addressId) => '$addressesEndpoint/$addressId';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
