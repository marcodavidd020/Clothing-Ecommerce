import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/core/constants/home_ui.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_item_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/category_ui_helper.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category/category_list_item_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget que muestra una sección de subcategorías
class CategorySectionWidget extends StatelessWidget {
  /// Lista de subcategorías a mostrar
  final List<CategoryApiModel> subcategories;

  /// Callback cuando se selecciona una categoría
  final void Function(CategoryApiModel category) onCategorySelected;

  /// Constructor
  const CategorySectionWidget({
    super.key,
    required this.subcategories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryUIHelper.buildSectionHeader(
          CategoryUIHelper.subcategoriasTitle,
        ),
        CategoryUIHelper.mediumVerticalSpacer(),
        _buildSubcategoriesList(context),
        CategoryUIHelper.largeVerticalSpacer(),
      ],
    );
  }

  /// Construye una lista vertical de subcategorías
  Widget _buildSubcategoriesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subcategories.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => CategoryUIHelper.smallVerticalSpacer(),
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return CategoryListItemWidget(
          category: CategoryItemModel(
            imageUrl: CategoryUIHelper.getCategoryImageUrl(subcategory),
            name: subcategory.name,
          ),
          onTap: () => onCategorySelected(subcategory),
          backgroundColor: AppColors.backgroundGray.withOpacity(0.5),
          trailingIcon: SvgPicture.asset(
            AppStrings.arrowRightIcon,
            width: HomeUI.productItemTrailingIconSize,
            height: HomeUI.productItemTrailingIconSize,
          ),
        );
      },
    );
  }
}
