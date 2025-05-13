import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar flutter_bloc
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart'
    as core_widgets;
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart'; // Usaremos el modelo de producto de home
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart'; // Importar widgets
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart'; // Importar el BLoC
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart'; // Importar bloc del carrito
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/helpers/helpers.dart';

/// Page that displays the details of a product.
class ProductDetailPage extends StatefulWidget {
  /// The product to display details for.
  final ProductItemModel product;

  /// Creates an instance of [ProductDetailPage].
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Keys for animation
  final GlobalKey _currentImageKey = GlobalKey();
  final GlobalKey _cartButtonKey = GlobalKey();
  final GlobalKey _carouselKey = GlobalKey();

  // Estado para controlar la visibilidad de la imagen durante la animación
  bool _imageVisibleInCarousel = true;

  @override
  void initState() {
    super.initState();
    // Product loading is handled in BlocProvider.create
  }

  /// Run the add to cart animation and then call the actual add to cart function later
  void _animateAddToCart(ProductDetailLoaded state) {
    String imageUrl = widget.product.imageUrl;

    // Ocultar la imagen en el carrusel durante la animación
    setState(() {
      _imageVisibleInCarousel = false;
    });

    AddToCartAnimationHelper.runAddToCartAnimation(
      context: context,
      sourceKey: _currentImageKey,
      targetKey: _cartButtonKey,
      imageUrl: imageUrl,
      onComplete: () {
        // Restaurar la visibilidad de la imagen cuando la animación termina
        if (mounted) {
          setState(() {
            _imageVisibleInCarousel = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get existing CartBloc or null if not found
    final cartBloc = CartIntegrationHelper.getExistingCartBloc(context);

    // Create product detail content with BlocProvider
    Widget productDetailContent = BlocProvider(
      create:
          (context) =>
              ProductDetailBloc(cartBloc: cartBloc)
                ..add(ProductDetailLoadRequested(product: widget.product)),
      child: Builder(
        // Añadimos un Builder para tener acceso al context con el provider
        builder: (builderContext) {
          return _ProductDetailScaffold(
            product: widget.product,
            currentImageKey: _currentImageKey,
            cartButtonKey: _cartButtonKey,
            carouselKey: _carouselKey,
            onAddToCart: _animateAddToCart,
            builderContext: builderContext,
            imageVisible: _imageVisibleInCarousel,
          );
        },
      ),
    );

    // Wrap with CartBloc if not found in tree
    if (cartBloc == null) {
      return BlocProvider(
        create: (context) => CartBloc()..add(const CartLoadRequested()),
        child: productDetailContent,
      );
    }

    // If CartBloc is available, just return the content
    return productDetailContent;
  }
}

/// Scaffold widget for the product detail page.
class _ProductDetailScaffold extends StatelessWidget {
  final ProductItemModel product;
  final GlobalKey currentImageKey;
  final GlobalKey cartButtonKey;
  final GlobalKey carouselKey;
  final Function(ProductDetailLoaded) onAddToCart;
  final BuildContext builderContext;
  final bool imageVisible;

  const _ProductDetailScaffold({
    required this.product,
    required this.currentImageKey,
    required this.cartButtonKey,
    required this.carouselKey,
    required this.onAddToCart,
    required this.builderContext,
    required this.imageVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // To back Home
    void onBack() {
      NavigationHelper.goToMainShell(context);
    }

    return core_widgets.CustomAppBar(
      showBack: true,
      onBack: onBack,
      title: _buildFavoriteButton(context),
      actions: [_buildCartButton()],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        bool isFavorite = false;
        if (state is ProductDetailLoaded) {
          isFavorite = state.isFavorite;
        }
        return FavoriteButtonWidget(
          isFavorite: isFavorite,
          onTap:
              () => FavoriteHelper.toggleFavorite(
                context,
                product.name,
                isFavorite,
              ),
        );
      },
    );
  }

  Widget _buildCartButton() {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.screenPadding),
      child: CartIconWidget(key: cartButtonKey),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductDetailError) {
          return const Center(
            child: Text(
              ProductDetailStrings.somethingWentWrong,
              style: AppTextStyles.errorText,
            ),
          );
        }

        final loadedState = state as ProductDetailLoaded;
        return _ProductDetailContent(
          loadedState: loadedState,
          currentImageKey: currentImageKey,
          carouselKey: carouselKey,
          imageVisible: imageVisible,
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoaded) {
          return BlocListener<CartBloc, CartState>(
            listener: (context, cartState) {
              // Show confirmation when product is added to cart
              if (cartState is CartLoaded) {
                CartIntegrationHelper.showAddedToCartMessage(
                  context,
                  ProductDetailStrings.addedToCartMessage,
                );
              }
            },
            child: AddToCartButtonWidget(
              totalPrice: state.product.price * state.quantity,
              onPressed: () {
                // Primero, animar el añadir al carrito
                onAddToCart(state);

                // Luego, ahora que estamos dentro del BuildContext correcto,
                // podemos acceder al bloc y agregar el producto al carrito
                Future.delayed(const Duration(milliseconds: 1200), () {
                  if (builderContext.mounted) {
                    builderContext.read<ProductDetailBloc>().add(
                      const ProductAddToCartRequested(),
                    );
                  }
                });
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Content widget for the product detail page.
class _ProductDetailContent extends StatelessWidget {
  final ProductDetailLoaded loadedState;
  final GlobalKey currentImageKey;
  final GlobalKey carouselKey;
  final bool imageVisible;

  const _ProductDetailContent({
    required this.loadedState,
    required this.currentImageKey,
    required this.carouselKey,
    required this.imageVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildMainContent(context), _buildLoadingIndicator(context)],
    );
  }

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

  Widget _buildImageCarousel() {
    return ImageCarouselWidget(
      key: carouselKey,
      imageList: [
        loadedState.product.imageUrl,
        ...loadedState.product.additionalImageUrls,
      ],
      currentImageKey: currentImageKey,
      isVisible: imageVisible,
    );
  }

  Widget _buildProductName() {
    return Text(
      loadedState.product.name,
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.nameFontSize,
      ),
    );
  }

  Widget _buildProductPrice() {
    return Text(
      '\$${loadedState.product.price.toStringAsFixed(2)}',
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.priceFontSize,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSizeSelector(BuildContext context) {
    return OptionSelectorWidget(
      label: ProductDetailStrings.sizeLabel,
      valueDisplay: Text(
        loadedState.selectedSize,
        style: AppTextStyles.inputText.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () => OptionPickerHelper.showSizePicker(context, loadedState),
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    return OptionSelectorWidget(
      label: ProductDetailStrings.colorLabel,
      valueDisplay: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: loadedState.selectedColor.color,
            radius: ProductDetailUI.colorSelectorValueAvatarRadius,
          ),
          const SizedBox(width: AppDimens.vSpace8),
          Text(
            loadedState.selectedColor.name,
            style: AppTextStyles.inputText.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () => OptionPickerHelper.showColorPicker(context, loadedState),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return QuantitySelectorWidget(
      quantity: loadedState.quantity,
      onDecrement: () {
        if (loadedState.quantity > 1) {
          context.read<ProductDetailBloc>().add(
            ProductDetailQuantityChanged(newQuantity: loadedState.quantity - 1),
          );
        }
      },
      onIncrement: () {
        context.read<ProductDetailBloc>().add(
          ProductDetailQuantityChanged(newQuantity: loadedState.quantity + 1),
        );
      },
    );
  }

  Widget _buildDescriptionTitle() {
    return Text(
      ProductDetailStrings.descriptionLabel,
      style: AppTextStyles.heading.copyWith(
        fontSize: ProductDetailUI.descriptionTitleFontSize,
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      loadedState.product.description,
      style: AppTextStyles.inputText.copyWith(
        color: AppColors.textGray,
        height: ProductDetailUI.descriptionLineHeight,
      ),
    );
  }

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
