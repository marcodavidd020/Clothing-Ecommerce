import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart'
    as core_widgets;
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';

/// Widget que implementa el Scaffold para la página de detalle de producto.
///
/// Maneja la estructura general de la página, incluyendo AppBar, cuerpo principal
/// y barra de navegación inferior.
class ProductDetailScaffoldWidget extends StatelessWidget {
  /// Key para la imagen actual (usada en animaciones)
  final GlobalKey currentImageKey;

  /// Key para el botón de carrito (usada en animaciones)
  final GlobalKey cartButtonKey;

  /// Key para el carrusel de imágenes
  final GlobalKey carouselKey;

  /// Función llamada cuando se agrega un producto al carrito
  final Function(ProductDetailLoaded) onAddToCart;

  /// Contexto del builder (para acceder al BLoC)
  final BuildContext builderContext;

  /// Controla si la imagen es visible en el carrusel
  final bool imageVisible;

  /// Constructor
  const ProductDetailScaffoldWidget({
    super.key,
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

  /// Construye la AppBar con botones de favorito y carrito
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Para volver a Home
    void onBack() {
      NavigationHelper.goToMainShell(context);
    }

    return core_widgets.CustomAppBar(
      showBack: true,
      onBack: onBack,
      title: _buildFavoriteButton(context),
      toolbarHeight: kToolbarHeight * 1.2,
      actions: [_buildCartButton(context)],
    );
  }

  /// Construye el botón de favoritos
  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoaded) {
          return FavoriteButtonWidget(
            isFavorite: state.isFavorite,
            onTap:
                () => FavoriteHelper.toggleFavorite(
                  context,
                  state.product.name,
                  state.isFavorite,
                ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Construye el icono del carrito con badge de cantidad
  Widget _buildCartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.appBarActionRightPadding),
      child: core_widgets.CartBadgeWidget(
        key: cartButtonKey,
        onPressed: () => NavigationHelper.goToCart(context),
      ),
    );
  }

  /// Construye el cuerpo principal de la página
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
        return ProductContentWidget(
          state: loadedState,
          imageKey: carouselKey,
          currentImageKey: currentImageKey,
          imageVisible: imageVisible,
          onSizeTap: OptionPickerHelper.showSizePicker,
          onColorTap: OptionPickerHelper.showColorPicker,
        );
      },
    );
  }

  /// Construye la barra inferior con botón de añadir al carrito
  Widget _buildBottomNavBar(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoaded) {
          return BlocListener<CartBloc, CartState>(
            listener: (context, cartState) {
              // Mostrar confirmación cuando el producto es añadido al carrito
              if (cartState is CartLoaded) {
                CartIntegrationHelper.showAddToCartSnackBar(
                  context: context,
                  success: true,
                  productName: state.product.name,
                  quantity: state.quantity,
                );
              }
            },
            child: AddToCartButtonWidget(
              totalPrice: state.product.price * state.quantity,
              onPressed: () {
                // Primero, animar el añadir al carrito
                onAddToCart(state);

                // Luego, con el BuildContext correcto,
                // añadir el producto al carrito
                Future.delayed(const Duration(milliseconds: 1200), () {
                  if (builderContext.mounted) {
                    builderContext.read<ProductDetailBloc>().add(
                      ProductAddToCartRequested(context: builderContext),
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
