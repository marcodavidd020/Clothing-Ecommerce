import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/cart_item_widget.dart';

/// A callback function type for handling item deletion confirmation.
typedef DeleteConfirmationCallback =
    Future<bool> Function(BuildContext context, CartItemModel item);

/// A callback function type for handling quantity changes.
typedef QuantityChangedCallback =
    void Function(BuildContext context, CartItemModel item, int newQuantity);

/// Widget that displays the list of cart items.
class CartItemListWidget extends StatelessWidget {
  /// The loaded cart state.
  final CartLoaded state;

  /// Callback for when the user confirms deletion of an item.
  final DeleteConfirmationCallback onDeleteConfirmation;

  /// Callback for when the quantity of an item changes.
  final QuantityChangedCallback onQuantityChanged;

  /// Creates an instance of [CartItemListWidget].
  const CartItemListWidget({
    super.key,
    required this.state,
    required this.onDeleteConfirmation,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimens.vSpace16),
      itemBuilder: (context, index) {
        final item = state.items[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(
              right: CartUI.dismissibleRightPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(
                (CartUI.dismissibleBackgroundOpacity * 255).round(),
              ),
              borderRadius: BorderRadius.circular(
                AppDimens.productItemBorderRadius,
              ),
            ),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: CartUI.dismissibleIconSize,
            ),
          ),
          confirmDismiss: (direction) => onDeleteConfirmation(context, item),
          onDismissed: (direction) {
            // The actual deletion happens in the onDeleteConfirmation callback
          },
          child: CartItemWidget(
            item: item,
            onRemove: () => onDeleteConfirmation(context, item),
            onQuantityChanged:
                (quantity) => onQuantityChanged(context, item, quantity),
          ),
        );
      },
    );
  }
}
