import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';

/// Button widget for adding products to cart.
class AddToCartButtonWidget extends StatelessWidget {
  /// The current price of the product (considering quantity).
  final double totalPrice;

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// Creates an instance of [AddToCartButtonWidget].
  const AddToCartButtonWidget({
    super.key,
    required this.totalPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      child: PrimaryButton(
        label:
            '\$${totalPrice.toStringAsFixed(2)}    ${ProductDetailStrings.addToBagLabel}',
        onPressed: onPressed,
      ),
    );
  }
}
