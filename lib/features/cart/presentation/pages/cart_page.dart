import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Página que muestra los productos en el carrito de compras.
class CartPage extends StatelessWidget {
  /// Crea una instancia de [CartPage].
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
                  padding: const EdgeInsets.only(right: AppDimens.screenPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_sweep, color: AppColors.error),
                      onPressed: () => _showClearCartConfirmation(context),
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
            // Cargar el carrito cuando se inicia la página
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
              return _buildEmptyCart();
            }

            return _buildCartItems(context, state);
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
                  _buildSummary(state),
                  const SizedBox(height: AppDimens.vSpace16),
                  PrimaryButton(
                    label:
                        '${CartStrings.checkoutButtonLabel}\$${state.totalPrice.toStringAsFixed(2)}',
                    onPressed: () {
                      // TODO: Implementar flujo de checkout
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

  /// Construye la vista cuando el carrito está vacío.
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Agregar una ilustración o ícono de carrito vacío
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppDimens.vSpace16),
          Text(
            CartStrings.emptyCartTitle,
            style: AppTextStyles.heading.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: AppDimens.vSpace8),
          Text(
            CartStrings.emptyCartMessage,
            style: AppTextStyles.body.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construye la lista de ítems del carrito.
  Widget _buildCartItems(BuildContext context, CartLoaded state) {
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
              color: AppColors.error.withOpacity(
                CartUI.dismissibleBackgroundOpacity,
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
          confirmDismiss: (direction) => _showDeleteConfirmation(context, item),
          onDismissed: (direction) {
            // La eliminación real ocurre en _showDeleteConfirmation
          },
          child: CartItemWidget(
            item: item,
            onRemove: () => _showDeleteConfirmation(context, item),
            onQuantityChanged:
                (quantity) => _onQuantityChanged(context, item, quantity),
          ),
        );
      },
    );
  }

  /// Muestra un diálogo de confirmación para eliminar un producto.
  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    CartItemModel item,
  ) async {
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

  /// Muestra un diálogo de confirmación para vaciar el carrito.
  Future<void> _showClearCartConfirmation(BuildContext context) async {
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

  /// Construye el resumen del carrito (subtotal, envío, total).
  Widget _buildSummary(CartLoaded state) {
    // Valores de ejemplo para envío e impuestos
    final double shipping = 5.99;
    final double tax = state.totalPrice * 0.07; // 7% de impuesto
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

  /// Construye una fila del resumen de costos.
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

  /// Maneja el cambio de cantidad de un ítem.
  void _onQuantityChanged(
    BuildContext context,
    CartItemModel item,
    int newQuantity,
  ) {
    if (newQuantity <= 0) {
      // Si es cero o menos, mostramos confirmación
      _showDeleteConfirmation(context, item);
    } else {
      context.read<CartBloc>().add(
        CartItemQuantityUpdated(itemId: item.id, newQuantity: newQuantity),
      );
    }
  }
}
