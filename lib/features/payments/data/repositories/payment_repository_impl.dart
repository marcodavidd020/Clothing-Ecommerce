import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/payment_api_model.dart';
import '../models/create_payment_request_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final DioClient _dioClient;

  PaymentRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Either<Failure, PaymentEntity>> createPayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
    String? provider,
  }) async {
    try {
      final createPaymentRequest = CreatePaymentRequestModel(
        provider: provider ?? 'Stripe',
        method: method.value,
        amount: amount,
      );

      final response = await _dioClient.post(
        ApiConstants.paymentsEndpoint,
        data: createPaymentRequest.toJson(),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        final paymentData = responseData['data'];
        
        final payment = PaymentApiModel.fromJson(paymentData).toEntity();
        return Right(payment);
      } else {
        return Left(ServerFailure(message: 'Error al crear pago: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> confirmPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.confirmPaymentEndpoint(paymentId),
        data: {'transactionId': transactionId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final paymentData = responseData['data'];
        
        final payment = PaymentApiModel.fromJson(paymentData).toEntity();
        return Right(payment);
      } else {
        return Left(ServerFailure(message: 'Error al confirmar pago: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> cancelPayment(String paymentId) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.cancelPaymentEndpoint(paymentId),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final paymentData = responseData['data'];
        
        final payment = PaymentApiModel.fromJson(paymentData).toEntity();
        return Right(payment);
      } else {
        return Left(ServerFailure(message: 'Error al cancelar pago: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentById(String paymentId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getPaymentEndpoint(paymentId),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final paymentData = responseData['data'];
        
        final payment = PaymentApiModel.fromJson(paymentData).toEntity();
        return Right(payment);
      } else {
        return Left(ServerFailure(message: 'Error al obtener pago: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getMyPayments() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.paymentsEndpoint,
        queryParameters: {
          'page': 1,
          'limit': 50,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> paymentsData = responseData['data'] ?? [];
        
        final payments = paymentsData
            .map((paymentJson) => PaymentApiModel.fromJson(paymentJson).toEntity())
            .toList();

        return Right(payments);
      } else {
        return Left(ServerFailure(message: 'Error al obtener historial de pagos: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Error de conexión: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPayment(String paymentId) async {
    return getPaymentById(paymentId);
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    // Devolver los métodos de pago disponibles basados en la enum
    return const Right([
      PaymentMethod.card,
      PaymentMethod.qr,
      PaymentMethod.paypal,
      PaymentMethod.bankTransfer,
    ]);
  }

  @override
  Future<Either<Failure, PaymentEntity>> processPayment({
    required String paymentId,
    required Map<String, dynamic> paymentData,
  }) async {
    // Para procesar el pago, usamos el endpoint de confirmación
    final transactionId = paymentData['transactionId'] as String? ?? '';
    return confirmPayment(
      paymentId: paymentId,
      transactionId: transactionId,
    );
  }
} 