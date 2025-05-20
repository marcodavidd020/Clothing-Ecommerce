import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/product_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Clase auxiliar para construir componentes de UI comunes en pantallas del módulo Home
class HomeUIHelpers {
  /// Constructor privado para prevenir instanciación
  HomeUIHelpers._();

  /// Construye un título de sección con botón "Ver todos" opcional
  static Widget buildSectionTitle({
    required String title,
    Color titleColor = AppColors.textDark,
    VoidCallback? onSeeAllPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(color: titleColor),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text(
              AppStrings.seeAllLabel,
              style: AppTextStyles.seeAll,
            ),
          ),
      ],
    );
  }

  /// Construye un espacio vertical estándar pequeño
  static Widget get smallVerticalSpace => 
      const SizedBox(height: AppDimens.vSpace16);

  /// Construye un espacio vertical estándar mediano
  static Widget get mediumVerticalSpace => 
      const SizedBox(height: AppDimens.vSpace24);

  /// Construye un espacio vertical estándar grande
  static Widget get largeVerticalSpace => 
      const SizedBox(height: AppDimens.vSpace32);

  /// Construye un contenedor para elementos de producto con un estilo consistente
  static Widget buildProductItemContainer({required Widget child}) {
    return Container(
      width: AppDimens.productItemWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppDimens.productItemBorderRadius,
        ),
        color: AppColors.backgroundGray,
      ),
      child: child,
    );
  }

  /// Construye una vista de carga (placeholder) que puede usarse durante la carga de datos
  static Widget get loadingPlaceholder => 
      const Center(child: CircularProgressIndicator());

  /// Formatea un precio para mostrar en la UI
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Formatea un precio tachado (original) para mostrar en la UI
  static String formatOriginalPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Determina si un producto tiene descuento
  static bool hasDiscount(ProductItemModel product) {
    return product.originalPrice != null && 
           product.originalPrice! > product.price;
  }

  /// Calcula el porcentaje de descuento de un producto
  static int calculateDiscountPercentage(ProductItemModel product) {
    if (!hasDiscount(product)) return 0;
    final discount = product.originalPrice! - product.price;
    return ((discount / product.originalPrice!) * 100).round();
  }
} 