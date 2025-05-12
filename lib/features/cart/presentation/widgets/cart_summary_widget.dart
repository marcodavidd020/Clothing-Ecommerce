import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Widget that displays the cart summary (subtotal, shipping, tax, total).
class CartSummaryWidget extends StatelessWidget {
  /// The state of the cart with pricing information.
  final CartLoaded state;

  /// Creates an instance of [CartSummaryWidget].
  const CartSummaryWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Example values for shipping and taxes
    final double shipping = 5.99;
    final double tax = state.totalPrice * 0.07; // 7% tax
    final double total = state.totalPrice + shipping + tax;

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
            '\$${state.totalPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppDimens.vSpace8),
          _buildSummaryRow(
            CartStrings.shippingLabel,
            '\$${shipping.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppDimens.vSpace8),
          _buildSummaryRow(CartStrings.taxLabel, '\$${tax.toStringAsFixed(2)}'),
          const Divider(height: 24, color: AppColors.textLight),
          _buildSummaryRow(
            CartStrings.totalLabel,
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  /// Builds a row in the cost summary.
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
