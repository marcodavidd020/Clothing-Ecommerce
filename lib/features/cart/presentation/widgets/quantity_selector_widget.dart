import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';

/// Widget que implementa un selector de cantidad con botones de incremento y decremento.
///
/// Puede ser utilizado en pantallas de carrito o detalle de producto.
class CartQuantitySelectorWidget extends StatelessWidget {
  /// Cantidad actual seleccionada
  final int quantity;

  /// Callback cuando cambia la cantidad
  final Function(int) onQuantityChanged;

  /// Valor mínimo permitido
  final int minValue;

  /// Valor máximo permitido
  final int maxValue;

  /// Constructor principal
  const CartQuantitySelectorWidget({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.minValue = 1,
    this.maxValue = 99,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed:
                quantity > minValue
                    ? () => onQuantityChanged(quantity - 1)
                    : null,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed:
                quantity < maxValue
                    ? () => onQuantityChanged(quantity + 1)
                    : null,
          ),
        ],
      ),
    );
  }

  /// Construye un botón para la selección de cantidad.
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final bool isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(CartUI.cartItemButtonRadius),
        child: Container(
          padding: EdgeInsets.all(CartUI.cartItemButtonSize),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: CartUI.cartItemButtonIconSize,
            color: isEnabled ? AppColors.primary : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
