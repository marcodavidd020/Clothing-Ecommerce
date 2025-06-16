class CreatePaymentRequestModel {
  final String provider;
  final String method;
  final double amount;
  final String? status;
  final String? transactionId;

  CreatePaymentRequestModel({
    required this.provider,
    required this.method,
    required this.amount,
    this.status,
    this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'method': method,
      'amount': amount,
      if (status != null) 'status': status,
      if (transactionId != null) 'transactionId': transactionId,
    };
  }
} 