import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper class for handling cart item quantity changes.
class CartQuantityHelper {
  /// Handles the quantity change for a cart item.
  /// 
  /// If the new quantity is zero or negative, shows a confirmation dialog
  /// to remove the item. Otherwise, updates the quantity in the cart.
  static void onQuantityChanged(
    BuildContext context,
    CartItemModel item,
    int newQuantity,
  ) {
    if (newQuantity <= 0) {
      // If zero or negative, show confirmation
      DeleteConfirmationDialog.show(context, item);
    } else {
      context.read<CartBloc>().add(
        CartItemQuantityUpdated(itemId: item.id, newQuantity: newQuantity),
      );
    }
  }
} 