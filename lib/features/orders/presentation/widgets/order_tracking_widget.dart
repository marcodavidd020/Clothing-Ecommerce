import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../../domain/entities/order_entity.dart';

class OrderTrackingWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderTrackingWidget({
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
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Seguimiento del Pedido',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            _buildTrackingSteps(context),
            
            if (order.status == OrderStatus.shipped || order.status == OrderStatus.delivered) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Número de seguimiento',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'TR${order.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _copyTrackingNumber(context),
                      child: const Text('Copiar'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingSteps(BuildContext context) {
    final steps = _getTrackingSteps();
    
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step.isCompleted
                        ? AppColors.primary
                        : step.isActive
                            ? Colors.orange[600]
                            : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.isCompleted
                        ? Icons.check
                        : step.isActive
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                    color: step.isCompleted || step.isActive
                        ? Colors.white
                        : Colors.grey[600],
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: step.isCompleted
                        ? AppColors.primary
                        : Colors.grey[300],
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Step content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: step.isCompleted || step.isActive
                            ? Colors.black87
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (step.date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(step.date!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  List<TrackingStep> _getTrackingSteps() {
    return [
      TrackingStep(
        title: 'Pedido Confirmado',
        description: 'Tu pedido ha sido recibido y confirmado',
        isCompleted: true,
        isActive: false,
        date: order.createdAt,
      ),
      TrackingStep(
        title: 'Pago Procesado',
        description: 'El pago ha sido verificado y procesado',
        isCompleted: order.paymentStatus == PaymentStatus.paid,
        isActive: order.paymentStatus == PaymentStatus.processing,
        date: order.paymentStatus == PaymentStatus.paid ? order.createdAt : null,
      ),
      TrackingStep(
        title: 'En Preparación',
        description: 'Tu pedido está siendo preparado para envío',
        isCompleted: _isStatusCompleted(OrderStatus.processing),
        isActive: order.status == OrderStatus.processing,
        date: _isStatusCompleted(OrderStatus.processing) ? order.createdAt : null,
      ),
      TrackingStep(
        title: 'Enviado',
        description: 'Tu pedido está en camino',
        isCompleted: _isStatusCompleted(OrderStatus.shipped),
        isActive: order.status == OrderStatus.shipped,
        date: order.shippedAt,
      ),
      TrackingStep(
        title: 'Entregado',
        description: 'Tu pedido ha sido entregado exitosamente',
        isCompleted: order.status == OrderStatus.delivered || order.status == OrderStatus.completed,
        isActive: false,
        date: order.deliveredAt,
      ),
    ];
  }

  bool _isStatusCompleted(OrderStatus status) {
    final orderStatusValues = OrderStatus.values;
    final currentIndex = orderStatusValues.indexOf(order.status);
    final targetIndex = orderStatusValues.indexOf(status);
    
    return currentIndex >= targetIndex;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _copyTrackingNumber(BuildContext context) {
    final trackingNumber = 'TR${order.id.substring(0, 8).toUpperCase()}';
    // TODO: Implementar copia al portapapeles
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Número de seguimiento copiado: $trackingNumber'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class TrackingStep {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final DateTime? date;

  TrackingStep({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isActive,
    this.date,
  });
} 