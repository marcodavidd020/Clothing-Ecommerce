import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product_item_widget.dart';

class TopSellingSection extends StatelessWidget {
  final List<ProductItemModel> products;
  final VoidCallback? onSeeAllPressed;
  final Function(ProductItemModel)? onProductTap;
  final Function(ProductItemModel)? onFavoriteToggle;

  const TopSellingSection({
    super.key,
    required this.products,
    this.onSeeAllPressed,
    this.onProductTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.topSellingTitle, style: AppTextStyles.categorySectionTitle),
            if (onSeeAllPressed != null)
              TextButton(
                onPressed: onSeeAllPressed,
                child: Text(AppStrings.seeAllTopSelling, style: AppTextStyles.seeAll),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.vSpace16),
        SizedBox(
          height: AppDimens.topSellingSectionHeight, // Altura aproximada para los items de producto
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemWidget(
                product: product,
                onTap: () => onProductTap?.call(product),
                onFavoriteToggle: () => onFavoriteToggle?.call(product),
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
