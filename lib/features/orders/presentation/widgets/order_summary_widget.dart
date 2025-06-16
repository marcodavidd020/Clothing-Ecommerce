import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../../domain/entities/order_entity.dart';

class OrderSummaryWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderSummaryWidget({
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
                  Icons.receipt_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumen de Precios',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildPriceRow(
              context,
              'Subtotal',
              order.subtotal,
              isSubtotal: true,
            ),
            
            if (order.discount > 0) ...[
              const SizedBox(height: 8),
              _buildPriceRow(
                context,
                'Descuento',
                -order.discount,
                isDiscount: true,
              ),
            ],
            
            if (order.tax > 0) ...[
              const SizedBox(height: 8),
              _buildPriceRow(
                context,
                'Impuestos',
                order.tax,
              ),
            ],
            
            if (order.shippingCost > 0) ...[
              const SizedBox(height: 8),
              _buildPriceRow(
                context,
                'Envío',
                order.shippingCost,
              ),
            ] else ...[
              const SizedBox(height: 8),
              _buildPriceRow(
                context,
                'Envío',
                0,
                isFree: true,
              ),
            ],
            
            const SizedBox(height: 16),
            
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            
            const SizedBox(height: 16),
            
            _buildPriceRow(
              context,
              'Total',
              order.total,
              isTotal: true,
            ),
            
            if (order.couponCode != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cupón aplicado: ${order.couponCode}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    double amount, {
    bool isSubtotal = false,
    bool isDiscount = false,
    bool isTotal = false,
    bool isFree = false,
  }) {
    final textStyle = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )
        : Theme.of(context).textTheme.bodyMedium;

    final amountStyle = isTotal
        ? textStyle?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          )
        : isDiscount
            ? textStyle?.copyWith(
                color: Colors.green[600],
                fontWeight: FontWeight.w600,
              )
            : textStyle?.copyWith(
                fontWeight: FontWeight.w600,
              );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle,
        ),
        if (isFree)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'GRATIS',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        else
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: amountStyle,
          ),
      ],
    );
  }
} 