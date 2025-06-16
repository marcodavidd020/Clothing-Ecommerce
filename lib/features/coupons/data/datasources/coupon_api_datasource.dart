import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import '../models/coupon_api_model.dart';

/// Fuente de datos remota para cupones
abstract class CouponApiDataSource {
  Future<List<CouponApiModel>> getMyCoupons();
  Future<CouponApiModel> applyCoupon(String code);
  Future<void> removeCoupon(String couponId);
  Future<bool> validateCoupon(String code, double orderAmount);
}

/// Implementación de la fuente de datos remota para cupones
class CouponApiRemoteDataSource implements CouponApiDataSource {
  final DioClient _dioClient;

  CouponApiRemoteDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<CouponApiModel>> getMyCoupons() async {
    try {
      AppLogger.logInfo('Llamando a getMyCoupons endpoint: ${ApiConstants.myCouponsEndpoint}');
      
      final response = await _dioClient.get(ApiConstants.myCouponsEndpoint);

      if (response.data['success'] == true) {
        final List<dynamic> couponsData = response.data['data'] ?? [];
        
        final List<CouponApiModel> coupons = couponsData
            .map((couponJson) => CouponApiModel.fromJson(couponJson))
            .toList();

        AppLogger.logSuccess('Cupones obtenidos exitosamente: ${coupons.length} cupones');
        return coupons;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al obtener cupones';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al obtener cupones: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en getMyCoupons: $e');
      throw Exception('Error al obtener cupones: $e');
    }
  }

  @override
  Future<CouponApiModel> applyCoupon(String code) async {
    try {
      AppLogger.logInfo('Llamando a applyCoupon endpoint: ${ApiConstants.applyCouponEndpoint}');
      
      final response = await _dioClient.post(
        ApiConstants.applyCouponEndpoint,
        data: {'code': code},
      );

      if (response.data['success'] == true) {
        final couponData = response.data['data'];
        final coupon = CouponApiModel.fromJson(couponData);
        
        AppLogger.logSuccess('Cupón aplicado exitosamente: ${coupon.code}');
        return coupon;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al aplicar cupón';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al aplicar cupón: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en applyCoupon: $e');
      throw Exception('Error al aplicar cupón: $e');
    }
  }

  @override
  Future<void> removeCoupon(String couponId) async {
    try {
      AppLogger.logInfo('Llamando a removeCoupon endpoint: ${ApiConstants.removeCouponEndpoint(couponId)}');
      
      final response = await _dioClient.delete(
        ApiConstants.removeCouponEndpoint(couponId),
      );

      if (response.data['success'] == true) {
        AppLogger.logSuccess('Cupón removido exitosamente');
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al remover cupón';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al remover cupón: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en removeCoupon: $e');
      throw Exception('Error al remover cupón: $e');
    }
  }

  @override
  Future<bool> validateCoupon(String code, double orderAmount) async {
    try {
      AppLogger.logInfo('Llamando a validateCoupon endpoint: ${ApiConstants.validateCouponEndpoint(code)}');
      
      final response = await _dioClient.post(
        ApiConstants.validateCouponEndpoint(code),
        data: {'orderAmount': orderAmount},
      );

      if (response.data['success'] == true) {
        final isValid = response.data['data']['isValid'] as bool? ?? false;
        AppLogger.logSuccess('Cupón validado: $isValid');
        return isValid;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al validar cupón';
        AppLogger.logError('Error en respuesta: $errorMessage');
        return false;
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en validateCoupon: $e');
      return false;
    }
  }
} 