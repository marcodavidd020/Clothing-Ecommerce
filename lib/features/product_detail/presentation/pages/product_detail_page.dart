import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    // Product loading is handled in BlocProvider.create
  }

  @override
  Widget build(BuildContext context) {
    // Get existing CartBloc or null if not found
    final cartBloc = CartIntegrationHelper.getExistingCartBloc(context);

    // Create product detail content with BlocProvider
    Widget productDetailContent = BlocProvider(
      create: (context) => ProductDetailBloc(cartBloc: cartBloc)
        ..add(ProductDetailLoadRequested(product: widget.product)),
      child: Scaffold(
        appBar: core_widgets.CustomAppBar(
          showBack: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: AppDimens.appBarActionRightPadding,
              ),
              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
                  bool isFavorite = false;
                  if (state is ProductDetailLoaded) {
                    isFavorite = state.isFavorite;
                  }
                  return FavoriteButtonWidget(
                    isFavorite: isFavorite,
                    onTap: () => FavoriteHelper.toggleFavorite(
                      context,
                      widget.product.name,
                      isFavorite,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailInitial || state is ProductDetailError) {
              return Center(
                child: state is ProductDetailInitial
                    ? const CircularProgressIndicator()
                    : const Text(
                        ProductDetailStrings.somethingWentWrong,
                        style: AppTextStyles.errorText,
                      ),
              );
            }

            // Once loaded, state is ProductDetailLoaded
            final loadedState = state as ProductDetailLoaded;

            return ProductContentWidget(
              state: loadedState,
              onSizeTap: OptionPickerHelper.showSizePicker,
              onColorTap: OptionPickerHelper.showColorPicker,
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
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
                    // Dispatch event to add to cart
                    context.read<ProductDetailBloc>().add(
                          const ProductAddToCartRequested(),
                        );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
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
