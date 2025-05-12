import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/confirm_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Utility class for handling cart clearing confirmation.
class ClearCartConfirmationDialog {
  /// Shows a dialog to confirm clearing the cart.
  static Future<void> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmDialogWidget(
          title: CartStrings.clearCartTitle,
          message: CartStrings.clearCartMessage,
          cancelText: CartStrings.cancelButtonLabel,
          confirmText: CartStrings.clearAllButtonLabel,
          icon: Icons.remove_shopping_cart_outlined,
          accentColor: AppColors.error,
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<CartBloc>().add(const CartCleared());
    }
  }
}
