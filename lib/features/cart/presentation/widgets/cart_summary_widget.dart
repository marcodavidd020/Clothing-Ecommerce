import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Widget que muestra el resumen del carrito con los datos reales de la API.
class CartSummaryWidget extends StatelessWidget {
  /// El estado del carrito con la información de precios.
  final CartLoaded state;

  /// Crea una instancia de [CartSummaryWidget].
  const CartSummaryWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Calcular subtotal basado en los items del carrito
    final double subtotal = _calculateSubtotal();

    return Container(
      padding: const EdgeInsets.all(AppDimens.contentPaddingHorizontal),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppDimens.productItemBorderRadius),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            CartStrings.subtotalLabel,
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          const Divider(height: 24, color: AppColors.textLight),
          _buildSummaryRow(
            CartStrings.totalLabel,
            '\$${state.totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  /// Calcula el subtotal sumando el precio de todos los items
  double _calculateSubtotal() {
    return state.items.fold(0.0, (sum, item) {
      // Usar precio con descuento si existe, sino el precio original
      final price = item.product.originalPrice ?? item.product.price;
      return sum + (price * item.quantity);
    });
  }

  /// Construye una fila en el resumen de costos.
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal
                  ? AppTextStyles.heading.copyWith(fontSize: 16)
                  : AppTextStyles.body,
        ),
        Text(
          value,
          style:
              isTotal
                  ? AppTextStyles.heading.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  )
                  : AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
