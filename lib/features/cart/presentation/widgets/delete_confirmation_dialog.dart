import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/confirm_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Utility class for handling item deletion confirmations.
class DeleteConfirmationDialog {
  /// Shows a dialog to confirm the deletion of a cart item.
  ///
  /// Returns true if the user confirms the deletion, false otherwise.
  static Future<bool> show(BuildContext context, CartItemModel item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmDialogWidget(
          title: CartStrings.removeItemTitle,
          message: CartStrings.removeItemMessage.replaceAll(
            '%s',
            item.product.name,
          ),
          cancelText: CartStrings.cancelButtonLabel,
          confirmText: CartStrings.removeButtonLabel,
          icon: Icons.delete_outlined,
          accentColor: AppColors.error,
        );
      },
    );

    if (result == true) {
      if (!context.mounted) return false;
      context.read<CartBloc>().add(CartItemRemoved(itemId: item.id));
      return true;
    }

    return false;
  }
}
