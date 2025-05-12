import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart';

/// Widget that displays the main content of the product detail.
class ProductContentWidget extends StatelessWidget {
  /// The loaded product state.
  final ProductDetailLoaded state;

  /// Callback for when the size selector is tapped.
  final Function(BuildContext, ProductDetailLoaded) onSizeTap;

  /// Callback for when the color selector is tapped.
  final Function(BuildContext, ProductDetailLoaded) onColorTap;
  
  /// Key for the product image to use in animations.
  final Key? imageKey;

  /// Creates an instance of [ProductContentWidget].
  const ProductContentWidget({
    super.key,
    required this.state,
    required this.onSizeTap,
    required this.onColorTap,
    this.imageKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.vSpace16),
          ImageCarouselWidget(
            key: imageKey,
            imageList: [
              state.product.imageUrl,
              ...state.product.additionalImageUrls,
            ],
          ),
          const SizedBox(height: AppDimens.vSpace16),
          _buildProductInfo(),
          const SizedBox(height: AppDimens.vSpace24),
          _buildSelectors(context),
          _buildQuantitySelector(context),
          const SizedBox(height: AppDimens.vSpace16),
          _buildDescription(),
          const SizedBox(height: AppDimens.vSpace32),
        ],
      ),
    );
  }

  /// Builds the product name and price section.
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.product.name,
          style: AppTextStyles.heading.copyWith(
            fontSize: ProductDetailUI.nameFontSize,
          ),
        ),
        const SizedBox(height: AppDimens.vSpace8),
        Text(
          '\$${state.product.price.toStringAsFixed(2)}',
          style: AppTextStyles.heading.copyWith(
            fontSize: ProductDetailUI.priceFontSize,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  /// Builds the size and color selectors.
  Widget _buildSelectors(BuildContext context) {
    return Column(
      children: [
        OptionSelectorWidget(
          label: ProductDetailStrings.sizeLabel,
          valueDisplay: Text(
            state.selectedSize,
            style: AppTextStyles.inputText.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => onSizeTap(context, state),
        ),
        OptionSelectorWidget(
          label: ProductDetailStrings.colorLabel,
          valueDisplay: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: state.selectedColor.color,
                radius: ProductDetailUI.colorSelectorValueAvatarRadius,
              ),
              const SizedBox(width: AppDimens.vSpace8),
              Text(
                state.selectedColor.name,
                style: AppTextStyles.inputText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => onColorTap(context, state),
        ),
      ],
    );
  }

  /// Builds the quantity selector.
  Widget _buildQuantitySelector(BuildContext context) {
    return QuantitySelectorWidget(
      quantity: state.quantity,
      onDecrement: () {
        if (state.quantity > 1) {
          context.read<ProductDetailBloc>().add(
            ProductDetailQuantityChanged(newQuantity: state.quantity - 1),
          );
        }
      },
      onIncrement: () {
        context.read<ProductDetailBloc>().add(
          ProductDetailQuantityChanged(newQuantity: state.quantity + 1),
        );
      },
    );
  }

  /// Builds the product description section.
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProductDetailStrings.descriptionLabel,
          style: AppTextStyles.heading.copyWith(
            fontSize: ProductDetailUI.descriptionTitleFontSize,
          ),
        ),
        const SizedBox(height: AppDimens.vSpace8),
        Text(
          state.product.description,
          style: AppTextStyles.inputText.copyWith(
            color: AppColors.textGray,
            height: ProductDetailUI.descriptionLineHeight,
          ),
        ),
      ],
    );
  }
}
