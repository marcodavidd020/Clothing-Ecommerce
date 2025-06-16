import 'package:flutter_application_ecommerce/core/constants/api_constants.dart';
import 'package:flutter_application_ecommerce/core/network/dio_client.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import '../models/payment_api_model.dart';

/// Fuente de datos remota para pagos
abstract class PaymentApiDataSource {
  Future<PaymentApiModel> createPayment(CreatePaymentApiModel payment);
  Future<List<String>> getPaymentMethods();
  Future<PaymentApiModel> processPayment(String paymentId, Map<String, dynamic> paymentData);
  Future<PaymentApiModel> getPaymentById(String paymentId);
}

/// Implementación de la fuente de datos remota para pagos
class PaymentApiRemoteDataSource implements PaymentApiDataSource {
  final DioClient _dioClient;

  PaymentApiRemoteDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<PaymentApiModel> createPayment(CreatePaymentApiModel payment) async {
    try {
      AppLogger.logInfo('Llamando a createPayment endpoint: ${ApiConstants.paymentsEndpoint}');
      
      final response = await _dioClient.post(
        ApiConstants.paymentsEndpoint,
        data: payment.toJson(),
      );

      if (response.data['success'] == true) {
        final paymentData = response.data['data'];
        final paymentModel = PaymentApiModel.fromJson(paymentData);
        
        AppLogger.logSuccess('Pago creado exitosamente: ${paymentModel.id}');
        return paymentModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al crear pago';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al crear pago: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en createPayment: $e');
      throw Exception('Error al crear pago: $e');
    }
  }

  @override
  Future<List<String>> getPaymentMethods() async {
    try {
      AppLogger.logInfo('Llamando a getPaymentMethods endpoint: ${ApiConstants.paymentMethodsEndpoint}');
      
      final response = await _dioClient.get(ApiConstants.paymentMethodsEndpoint);

      if (response.data['success'] == true) {
        final List<dynamic> methodsData = response.data['data'] ?? [];
        final methods = methodsData.map((method) => method.toString()).toList();
        
        AppLogger.logSuccess('Métodos de pago obtenidos exitosamente: ${methods.length}');
        return methods;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al obtener métodos de pago';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al obtener métodos de pago: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en getPaymentMethods: $e');
      throw Exception('Error al obtener métodos de pago: $e');
    }
  }

  @override
  Future<PaymentApiModel> processPayment(String paymentId, Map<String, dynamic> paymentData) async {
    try {
      AppLogger.logInfo('Llamando a processPayment endpoint: ${ApiConstants.paymentsEndpoint}/$paymentId/process');
      
      final response = await _dioClient.post(
        '${ApiConstants.paymentsEndpoint}/$paymentId/process',
        data: paymentData,
      );

      if (response.data['success'] == true) {
        final processedPaymentData = response.data['data'];
        final paymentModel = PaymentApiModel.fromJson(processedPaymentData);
        
        AppLogger.logSuccess('Pago procesado exitosamente: ${paymentModel.id}');
        return paymentModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al procesar pago';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al procesar pago: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en processPayment: $e');
      throw Exception('Error al procesar pago: $e');
    }
  }

  @override
  Future<PaymentApiModel> getPaymentById(String paymentId) async {
    try {
      AppLogger.logInfo('Llamando a getPaymentById endpoint: ${ApiConstants.getPaymentEndpoint(paymentId)}');
      
      final response = await _dioClient.get(ApiConstants.getPaymentEndpoint(paymentId));

      if (response.data['success'] == true) {
        final paymentData = response.data['data'];
        final paymentModel = PaymentApiModel.fromJson(paymentData);
        
        AppLogger.logSuccess('Pago obtenido exitosamente: ${paymentModel.id}');
        return paymentModel;
      } else {
        final errorMessage = response.data['message'] ?? 'Error desconocido al obtener pago';
        AppLogger.logError('Error en respuesta: $errorMessage');
        throw Exception('Error al obtener pago: $errorMessage');
      }
    } catch (e) {
      AppLogger.logError('EXCEPTION en getPaymentById: $e');
      throw Exception('Error al obtener pago: $e');
    }
  }
} 