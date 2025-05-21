import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Widget reutilizable que muestra breadcrumbs para la navegación jerárquica de categorías.
///
/// Este widget muestra una ruta de navegación a través de las categorías padre
/// hasta la categoría actual, permitiendo navegar hacia cualquiera de las categorías
/// en el camino.
class CategoryBreadcrumbsWidget extends StatelessWidget {
  /// Lista ordenada de categorías que forman la ruta jerárquica (de raíz a categoría actual)
  final List<CategoryApiModel> path;

  /// Callback cuando se presiona una categoría en el breadcrumb
  final Function(CategoryApiModel category)? onCategoryTap;

  /// Constructor
  const CategoryBreadcrumbsWidget({
    super.key,
    required this.path,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay ruta o es solo un elemento, no mostramos breadcrumbs
    if (path.isEmpty || path.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
      alignment: Alignment.bottomLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              path.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isLast = index == path.length - 1;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap:
                          isLast ? null : () => onCategoryTap?.call(category),
                      child: Text(
                        category.name,
                        style: AppTextStyles.body.copyWith(
                          color:
                              isLast ? AppColors.primary : AppColors.textLight,
                          fontSize: 12,
                          fontWeight:
                              isLast ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (!isLast) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
