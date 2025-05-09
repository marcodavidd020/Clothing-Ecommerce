import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryItemModel category;
  final VoidCallback? onTap;

  const CategoryItemWidget({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppDimens.categoriesItemImageSize,
            height: AppDimens.categoriesItemImageSize,
            child: NetworkImageWithPlaceholder(
              imageUrl: category.imageUrl,
              shape: BoxShape.circle,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppDimens.vSpace16 / 2),
          Text(
            category.name,
            style: AppTextStyles.categoryItem,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
