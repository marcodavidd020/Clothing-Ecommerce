import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
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
    AppLogger.logInfo('Cambio de cantidad solicitado para ${item.product.name}: ${item.quantity} -> $newQuantity');
    
    if (newQuantity <= 0) {
      AppLogger.logInfo('Cantidad <= 0, mostrando diálogo de confirmación para eliminar');
      // If zero or negative, show confirmation
      DeleteConfirmationDialog.show(context, item);
    } else {
      AppLogger.logInfo('Actualizando cantidad en el carrito via CartQuantityHelper');
      context.read<CartBloc>().add(
        CartItemQuantityUpdated(itemId: item.id, newQuantity: newQuantity),
      );
    }
  }
} 