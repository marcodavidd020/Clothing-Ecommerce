import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Widget que muestra el ícono del carrito con un badge/contador de ítems.
class CartBadgeWidget extends StatelessWidget {
  /// Callback para cuando se presiona el botón del carrito.
  final VoidCallback onPressed;

  /// Color de fondo del ícono (por defecto, AppColors.inputFill).
  final Color backgroundColor;

  /// Tamaño del botón (por defecto, AppDimens.backButtonSize).
  final double size;

  /// Crea un nuevo CartBadgeWidget.
  const CartBadgeWidget({
    super.key,
    required this.onPressed,
    this.backgroundColor = AppColors.inputFill,
    this.size = AppDimens.backButtonSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;

        if (state is CartLoaded) {
          itemCount = state.itemCount;
        }

        return GestureDetector(
          onTap: onPressed,
          child: Stack(
            children: [
              // Círculo de fondo con icono
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppStrings.bagIcon,
                    width: AppDimens.iconSize * 0.8,
                    height: AppDimens.iconSize * 0.8,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textDark,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Badge con cantidad (sólo si hay ítems)
              if (itemCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: size * 0.4,
                      minHeight: size * 0.4,
                    ),
                    child: Center(
                      child: Text(
                        itemCount > 9 ? '9+' : itemCount.toString(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
