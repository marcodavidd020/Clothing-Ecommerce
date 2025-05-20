import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Widget que muestra el contenido principal del detalle de producto.
class ProductContentWidget extends StatelessWidget {
  /// El estado cargado del producto.
  final ProductDetailLoaded state;

  /// Función de callback cuando se presiona el selector de talla.
  final Function(BuildContext, ProductDetailLoaded) onSizeTap;

  /// Función de callback cuando se presiona el selector de color.
  final Function(BuildContext, ProductDetailLoaded) onColorTap;

  /// Key para el carrusel de imágenes.
  final Key? imageKey;

  /// Key para la imagen actual (usado en animaciones).
  final GlobalKey? currentImageKey;

  /// Indica si la imagen es visible.
  final bool imageVisible;

  /// Constructor principal.
  const ProductContentWidget({
    super.key,
    required this.state,
    required this.onSizeTap,
    required this.onColorTap,
    this.imageKey,
    this.currentImageKey,
    this.imageVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildMainContent(context), _buildLoadingIndicator(context)],
    );
  }

  /// Construye el contenido principal desplazable.
  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.vSpace16),
          _buildImageCarousel(),
          const SizedBox(height: AppDimens.vSpace16),
          _buildProductName(),
          const SizedBox(height: AppDimens.vSpace8),
          _buildProductPrice(),
          const SizedBox(height: AppDimens.vSpace24),
          _buildSizeSelector(context),
          _buildColorSelector(context),
          _buildQuantitySelector(context),
          const SizedBox(height: AppDimens.vSpace16),
          _buildDescriptionTitle(),
          const SizedBox(height: AppDimens.vSpace8),
          _buildDescriptionText(),
          const SizedBox(height: AppDimens.vSpace32),
        ],
      ),
    );
  }

  /// Construye el carrusel de imágenes.
  Widget _buildImageCarousel() {
    return ImageCarouselWidget(
      key: imageKey,
      imageList: [state.product.imageUrl, ...state.product.additionalImageUrls],
      currentImageKey: currentImageKey,
      isVisible: imageVisible,
    );
  }

  /// Construye el nombre del producto.
  Widget _buildProductName() {
    return Text(
      state.product.name,
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.nameFontSize,
      ),
    );
  }

  /// Construye el precio del producto.
  Widget _buildProductPrice() {
    return Text(
      '\$${state.product.price.toStringAsFixed(2)}',
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.priceFontSize,
        color: AppColors.primary,
      ),
    );
  }

  /// Construye el selector de talla.
  Widget _buildSizeSelector(BuildContext context) {
    return OptionSelectorWidget(
      label: ProductDetailStrings.sizeLabel,
      valueDisplay: Text(
        state.selectedSize,
        style: AppTextStyles.inputText.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () => onSizeTap(context, state),
    );
  }

  /// Construye el selector de color.
  Widget _buildColorSelector(BuildContext context) {
    return OptionSelectorWidget(
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
    );
  }

  /// Construye el selector de cantidad.
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

  /// Construye el título de la descripción.
  Widget _buildDescriptionTitle() {
    return Text(
      ProductDetailStrings.descriptionLabel,
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.descriptionTitleFontSize,
      ),
    );
  }

  /// Construye el texto de la descripción.
  Widget _buildDescriptionText() {
    return Text(
      state.product.description,
      style: AppTextStyles.inputText.copyWith(
        color: AppColors.textGray,
        height: ProductDetailUI.descriptionLineHeight,
      ),
    );
  }

  /// Construye el indicador de carga para el carrito.
  Widget _buildLoadingIndicator(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is CartLoading) {
          return const Positioned(
            top: 20,
            right: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
