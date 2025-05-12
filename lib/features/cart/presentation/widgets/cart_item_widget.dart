import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Widget que representa un ítem en el carrito de compras.
class CartItemWidget extends StatelessWidget {
  /// El modelo de datos del ítem del carrito.
  final CartItemModel item;

  /// Callback cuando se presiona el botón de eliminar.
  final VoidCallback onRemove;

  /// Callback cuando cambia la cantidad.
  final Function(int) onQuantityChanged;

  /// Crea una instancia de [CartItemWidget].
  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: CartUI.verticalSpacing8),
      padding: const EdgeInsets.all(AppDimens.contentPaddingHorizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.productItemBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(CartUI.shadowOpacity),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del producto con borde más redondeado
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppDimens.productItemBorderRadius,
            ),
            child: NetworkImageWithPlaceholder(
              imageUrl: item.product.imageUrl,
              width: CartUI.cartItemImageSize,
              height: CartUI.cartItemImageSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppDimens.vSpace16),
          // Detalles del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimens.vSpace8),
                Row(
                  children: [
                    Container(
                      width: CartUI.cartItemColorCircleSize,
                      height: CartUI.cartItemColorCircleSize,
                      decoration: BoxDecoration(
                        color: item.color.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.optionBorder),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Color: ${item.color.name}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: AppDimens.vSpace8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(
                          CartUI.cartItemSizeBorderRadius,
                        ),
                      ),
                      child: Text(
                        'Size: ${item.size}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.vSpace12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildQuantitySelector(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el selector de cantidad con botones + y -.
  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(
          CartUI.cartItemQuantitySelectorBorderRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () => onQuantityChanged(item.quantity - 1),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.quantity.toString(),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () => onQuantityChanged(item.quantity + 1),
          ),
        ],
      ),
    );
  }

  /// Construye un botón para la selección de cantidad.
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(CartUI.cartItemButtonRadius),
        child: Container(
          padding: EdgeInsets.all(CartUI.cartItemButtonSize),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: CartUI.cartItemButtonIconSize,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
