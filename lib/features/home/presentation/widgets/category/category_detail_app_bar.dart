import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category/category_breadcrumbs_widget.dart';

/// AppBar personalizado para la página de detalle de categoría con soporte para breadcrumbs
class CategoryDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// La categoría actual seleccionada
  final CategoryApiModel category;

  /// Todas las categorías disponibles (necesario para construir la ruta de navegación)
  final List<CategoryApiModel> allCategories;

  /// Callback cuando se selecciona una categoría desde las breadcrumbs
  final void Function(CategoryApiModel) onCategoryTap;

  /// Constructor
  const CategoryDetailAppBar({
    super.key,
    required this.category,
    required this.allCategories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener la ruta de categorías para mostrar breadcrumbs si hay más de un nivel
    final categoryPath = category.getPathFromRoot(allCategories);
    final bool showBreadcrumbs = categoryPath.length > 1;

    return CustomAppBar(
      showBack: true,
      titleText: category.name,
      toolbarHeight: showBreadcrumbs ? kToolbarHeight + 40 : kToolbarHeight,
      actions:
          showBreadcrumbs
              ? [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CategoryBreadcrumbsWidget(
                    path: categoryPath,
                    onCategoryTap: onCategoryTap,
                  ),
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    category.getPathFromRoot(allCategories).length > 1
        ? kToolbarHeight + 40
        : kToolbarHeight,
  );
}
