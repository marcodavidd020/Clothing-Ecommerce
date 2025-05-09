import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'category_item_widget.dart';

class CategoriesSectionWidget extends StatelessWidget {
  final List<CategoryItemModel> categories;
  final VoidCallback? onSeeAllPressed;
  final Function(CategoryItemModel)? onCategoryTap;

  const CategoriesSectionWidget({
    super.key,
    required this.categories,
    this.onSeeAllPressed,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.categoriesTitle,
              style: AppTextStyles.categorySectionTitle,
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
        ),
        SizedBox(
          height: AppDimens.categoriesItemHeight, // Altura aproximada para los items y el texto
          child: ListView.separated(
            // padding: const EdgeInsets.symmetric(
            //   horizontal: AppDimens.screenPadding,
            // ),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItemWidget(
                category: category,
                onTap: () => onCategoryTap?.call(category),
              );
            },
            separatorBuilder:
                (context, index) => const SizedBox(width: AppDimens.vSpace16),
          ),
        ),
      ],
    );
  }
}
