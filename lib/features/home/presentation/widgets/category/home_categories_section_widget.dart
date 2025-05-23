import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/home_navigation_helper.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category/category_item_widget.dart';

/// Widget para mostrar la sección de categorías en la página Home
class HomeCategoriesSection extends StatelessWidget {
  /// Categoría raíz seleccionada
  final CategoryApiModel? selectedRootCategory;

  /// Lista de todas las categorías
  final List<CategoryApiModel> allCategories;

  /// Callback cuando se presiona "Ver todas"
  final VoidCallback onSeeAllPressed;

  /// Constructor
  const HomeCategoriesSection({
    super.key,
    required this.selectedRootCategory,
    required this.allCategories,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedRootCategory == null) {
      return const SizedBox.shrink();
    }

    // Obtenemos las subcategorías directamente del modelo API
    final List<CategoryApiModel> childCategories =
        selectedRootCategory!.children;

    // Si no hay categorías hijas, mostrar un mensaje
    if (childCategories.isEmpty) {
      return _buildEmptyCategoriesSection();
    }

    // Crear la UI para mostrar las categorías en formato carrusel
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                // selectedRootCategory == null ? 'Categorías' : 'Subcategorías de ${selectedRootCategory!.name}',
                AppStrings.categoriesTitle,
                style: AppTextStyles.sectionTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(AppStrings.seeAllLabel, style: AppTextStyles.seeAll),
            ),
          ],
        ),
        SizedBox(
          height: AppDimens.categoriesItemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: childCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, childCategories[index]);
            },
            separatorBuilder:
                (context, index) => const SizedBox(width: AppDimens.vSpace16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.vSpace16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subcategorías de ${selectedRootCategory!.name}',
                style: AppTextStyles.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.vSpace16),
          const Center(
            child: Text(
              'No hay subcategorías disponibles',
              style: TextStyle(
                color: AppColors.textDark,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryApiModel apiCategory,
  ) {
    // Creamos un CategoryItemModel solo para presentación, pero guardamos el original
    final displayCategory = CategoryItemModel(
      imageUrl: apiCategory.imageUrl ?? 'https://via.placeholder.com/150',
      name: apiCategory.name,
    );

    return CategoryItemWidget(
      category: displayCategory,
      onTap: () {
        // Verificamos si tiene hijos directamente mirando la lista de hijos
        // Si tiene subcategorías o no, navegamos a la vista de categoría
        HomeNavigationHelper.navigateAfterCategoryLoaded(
          context,
          apiCategory,
          allCategories,
        );
      },
    );
  }
}
