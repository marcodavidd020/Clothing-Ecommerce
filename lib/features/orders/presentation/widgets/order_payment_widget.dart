import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../../domain/entities/order_entity.dart';

class OrderPaymentWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderPaymentWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Información de Pago',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estado del pago
            _buildPaymentStatus(context),
            
            const SizedBox(height: 16),
            
            // Método de pago (si está disponible)
            _buildPaymentMethod(context),
            
            // Acciones según el estado del pago
            if (order.paymentStatus != PaymentStatus.paid) ...[
              const SizedBox(height: 20),
              _buildPaymentActions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus(BuildContext context) {
    final status = order.paymentStatus;
    final statusInfo = _getPaymentStatusInfo(status);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusInfo.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusInfo.iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              statusInfo.icon,
              color: statusInfo.iconColor,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusInfo.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusInfo.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: statusInfo.textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          
          if (status == PaymentStatus.paid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '✓ PAGADO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    // En este ejemplo usamos información simulada
    // TODO: Obtener método de pago real de la orden
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.credit_card,
              color: Colors.blue[600],
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarjeta de Crédito',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '**** **** **** 1234',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'VISA',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentActions(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orange[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pago Pendiente',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tu pedido está reservado. Completa el pago para procesar el envío.',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Botones de acción
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _processPayment(context),
                icon: const Icon(Icons.payment),
                label: const Text('Pagar Ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _changePaymentMethod(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Cambiar Método'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  PaymentStatusInfo _getPaymentStatusInfo(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return PaymentStatusInfo(
          title: 'Pago Pendiente',
          description: 'Esperando confirmación del pago',
          icon: Icons.schedule,
          backgroundColor: Colors.orange[50]!,
          borderColor: Colors.orange[200]!,
          iconBackgroundColor: Colors.orange[100]!,
          iconColor: Colors.orange[600]!,
          textColor: Colors.orange[700]!,
        );
      case PaymentStatus.processing:
        return PaymentStatusInfo(
          title: 'Procesando Pago',
          description: 'Tu pago está siendo verificado',
          icon: Icons.sync,
          backgroundColor: Colors.blue[50]!,
          borderColor: Colors.blue[200]!,
          iconBackgroundColor: Colors.blue[100]!,
          iconColor: Colors.blue[600]!,
          textColor: Colors.blue[700]!,
        );
      case PaymentStatus.paid:
        return PaymentStatusInfo(
          title: 'Pago Confirmado',
          description: 'Tu pago ha sido procesado exitosamente',
          icon: Icons.check_circle,
          backgroundColor: Colors.green[50]!,
          borderColor: Colors.green[200]!,
          iconBackgroundColor: Colors.green[100]!,
          iconColor: Colors.green[600]!,
          textColor: Colors.green[700]!,
        );
      case PaymentStatus.failed:
        return PaymentStatusInfo(
          title: 'Pago Fallido',
          description: 'Hubo un problema con el pago',
          icon: Icons.error,
          backgroundColor: Colors.red[50]!,
          borderColor: Colors.red[200]!,
          iconBackgroundColor: Colors.red[100]!,
          iconColor: Colors.red[600]!,
          textColor: Colors.red[700]!,
        );
      case PaymentStatus.cancelled:
        return PaymentStatusInfo(
          title: 'Pago Cancelado',
          description: 'El pago fue cancelado',
          icon: Icons.cancel,
          backgroundColor: Colors.grey[50]!,
          borderColor: Colors.grey[300]!,
          iconBackgroundColor: Colors.grey[100]!,
          iconColor: Colors.grey[600]!,
          textColor: Colors.grey[700]!,
        );
      case PaymentStatus.refunded:
        return PaymentStatusInfo(
          title: 'Pago Reembolsado',
          description: 'El reembolso ha sido procesado',
          icon: Icons.undo,
          backgroundColor: Colors.amber[50]!,
          borderColor: Colors.amber[200]!,
          iconBackgroundColor: Colors.amber[100]!,
          iconColor: Colors.amber[600]!,
          textColor: Colors.amber[700]!,
        );
    }
  }

  void _processPayment(BuildContext context) {
    // TODO: Implementar procesamiento de pago
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirigiendo a pasarela de pago...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _changePaymentMethod(BuildContext context) {
    // TODO: Implementar cambio de método de pago
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de cambio de método en desarrollo'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PaymentStatusInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;

  PaymentStatusInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
  });
} 