import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Page that displays the products in the shopping cart.
class CartPage extends StatelessWidget {
  /// Creates an instance of [CartPage].
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: CartStrings.cartTitle,
        showBack: true,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && !state.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimens.appBarActionRightPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_sweep, color: AppColors.error),
                      onPressed: () => ClearCartConfirmationDialog.show(context),
                      tooltip: CartStrings.removeAllButtonTooltip,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            // Load the cart when the page initializes
            context.read<CartBloc>().add(const CartLoadRequested());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.errorText),
            );
          }

          if (state is CartLoaded) {
            if (state.isEmpty) {
              return const EmptyCartWidget();
            }

            return CartItemListWidget(
              state: state,
              onDeleteConfirmation: DeleteConfirmationDialog.show,
              onQuantityChanged: CartQuantityHelper.onQuantityChanged,
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && !state.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppDimens.screenPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CartSummaryWidget(state: state),
                  const SizedBox(height: AppDimens.vSpace16),
                  PrimaryButton(
                    label:
                        '${CartStrings.checkoutButtonLabel}\$${state.totalPrice.toStringAsFixed(2)}',
                    onPressed: () {
                      // TODO: Implement checkout flow
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(CartStrings.checkoutComingSoon),
                          duration: Duration(
                            seconds: CartUI.snackBarDurationSeconds,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
