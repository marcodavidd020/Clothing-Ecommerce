import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar flutter_bloc
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart' as core_widgets;
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart'; // Usaremos el modelo de producto de home
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart'; // Importar widgets
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart'; // Importar el BLoC
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductItemModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Las variables de estado _selectedSize, _selectedColor, _quantity se eliminarán
  // y se leerán del ProductDetailBloc

  @override
  void initState() {
    super.initState();
    // Disparar el evento para cargar los datos del producto cuando la página se inicializa
    // No es necesario si BlocProvider.create lo hace, o si se pasa el producto directamente al BLoC
    // context.read<ProductDetailBloc>().add(ProductDetailLoadRequested(product: widget.product));
    // Esto se hará en el `create` del BlocProvider para asegurar que el producto esté disponible desde el inicio.
  }

  void _onFavoriteToggle(BuildContext context, bool currentIsFavorite) {
    // TODO: Implementar lógica de favoritos a través del BLoC
    // context.read<ProductDetailBloc>().add(ProductFavoriteToggled());
    print('Favorito presionado para ${widget.product.name}');
  }

  void _showSizePicker(BuildContext context, ProductDetailLoaded state) {
    if (state.product.availableSizes.isEmpty) return;

    final productDetailBloc = context.read<ProductDetailBloc>(); // Leer el BLoC aquí

    final List<core_widgets.OptionData> sizeOptions = state.product.availableSizes.map((size) {
      return core_widgets.OptionData(text: size);
    }).toList();
    int selectedSizeIndex = state.product.availableSizes.indexOf(state.selectedSize);
    if (selectedSizeIndex == -1) selectedSizeIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext sfContext, StateSetter setStateModal) {
            return core_widgets.OptionSelectorWidget(
              title: AppStrings.sizeLabel,
              options: sizeOptions,
              selectedIndex: selectedSizeIndex,
              onOptionSelected: (index) {
                setStateModal(() {
                  selectedSizeIndex = index;
                });
                productDetailBloc.add(
                      ProductDetailSizeSelected(newSize: state.product.availableSizes[index]),
                    );
              },
              onClose: () {
                Navigator.pop(modalContext);
              },
            );
          }
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ProductDetailLoaded state) {
    if (state.product.availableColors.isEmpty) return;

    final productDetailBloc = context.read<ProductDetailBloc>(); // Leer el BLoC aquí

    final List<core_widgets.OptionData> colorOptions = state.product.availableColors.map((colorChoice) {
      return core_widgets.OptionData(text: colorChoice.name, colorValue: colorChoice.color);
    }).toList();
    int selectedColorIndex = state.product.availableColors.indexWhere((c) => c.name == state.selectedColor.name);
    if (selectedColorIndex == -1) selectedColorIndex = 0;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(
              builder: (BuildContext sfContext, StateSetter setStateModal) {
            return core_widgets.OptionSelectorWidget(
              title: AppStrings.colorLabel,
              options: colorOptions,
              selectedIndex: selectedColorIndex,
              onOptionSelected: (index) {
                setStateModal(() {
                  selectedColorIndex = index;
                });
                productDetailBloc.add(
                      ProductDetailColorSelected(newColor: state.product.availableColors[index]),
                    );
              },
              onClose: () {
                Navigator.pop(modalContext);
              },
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProductDetailBloc()
                ..add(ProductDetailLoadRequested(product: widget.product)),
      child: Scaffold(
        // El appBar y el body ahora usarán BlocBuilder para acceder al estado
        appBar: core_widgets.CustomAppBar(
          showBack: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: AppDimens.appBarActionRightPadding,
              ),
              // Usar BlocBuilder aquí para el ícono de favorito
              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
                  bool isFavorite = false;
                  if (state is ProductDetailLoaded) {
                    isFavorite = state.isFavorite;
                  }
                  return GestureDetector(
                    onTap:
                        () => _onFavoriteToggle(
                          context,
                          isFavorite,
                        ), // Pasar el contexto y estado actual
                    child: Container(
                      width: AppDimens.backButtonSize,
                      height: AppDimens.backButtonSize,
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppStrings.heartIcon,
                          width: AppDimens.iconSize * 0.8,
                          height: AppDimens.iconSize * 0.8,
                          colorFilter: ColorFilter.mode(
                            isFavorite ? AppColors.primary : AppColors.textDark,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
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
              // Mostrar un indicador de carga o un mensaje de error
              // Por ahora, un simple indicador de carga si es inicial, o error.
              // En un caso real, ProductDetailError podría tener un mensaje específico.
              return Center(
                child:
                    state is ProductDetailInitial
                        ? const CircularProgressIndicator()
                        : const Text(
                          AppStrings.somethingWentWrong,
                          style: AppTextStyles.errorText,
                        ),
              );
            }

            // Una vez cargado, state es ProductDetailLoaded
            final loadedState = state as ProductDetailLoaded;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.vSpace16),
                  ImageCarouselWidget(
                    imageList: [
                      loadedState.product.imageUrl,
                      ...loadedState.product.additionalImageUrls,
                    ],
                  ),
                  const SizedBox(height: AppDimens.vSpace16),
                  Text(
                    loadedState.product.name,
                    style: AppTextStyles.heading.copyWith(
                      fontSize: AppDimens.productDetailNameFontSize,
                    ),
                  ),
                  const SizedBox(height: AppDimens.vSpace8),
                  Text(
                    '\$${loadedState.product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.heading.copyWith(
                      fontSize: AppDimens.productDetailPriceFontSize,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.vSpace24),
                  OptionSelectorWidget(
                    label: AppStrings.sizeLabel,
                    valueDisplay: Text(
                      loadedState.selectedSize,
                      style: AppTextStyles.inputText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showSizePicker(context, loadedState),
                  ),
                  OptionSelectorWidget(
                    label: AppStrings.colorLabel,
                    valueDisplay: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: loadedState.selectedColor.color,
                          radius: AppDimens.colorSelectorValueAvatarRadius,
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
                    onTap: () => _showColorPicker(context, loadedState),
                  ),
                  QuantitySelectorWidget(
                    quantity: loadedState.quantity,
                    onDecrement: () {
                      if (loadedState.quantity > 1) {
                        context.read<ProductDetailBloc>().add(
                          ProductDetailQuantityChanged(
                            newQuantity: loadedState.quantity - 1,
                          ),
                        );
                      }
                    },
                    onIncrement: () {
                      context.read<ProductDetailBloc>().add(
                        ProductDetailQuantityChanged(
                          newQuantity: loadedState.quantity + 1,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppDimens.vSpace16),
                  Text(
                    AppStrings.descriptionLabel,
                    style: AppTextStyles.heading.copyWith(
                      fontSize: AppDimens.descriptionTitleFontSize,
                    ),
                  ),
                  const SizedBox(height: AppDimens.vSpace8),
                  Text(
                    loadedState.product.description,
                    style: AppTextStyles.inputText.copyWith(
                      color: AppColors.textGray,
                      height: AppDimens.descriptionLineHeight,
                    ),
                  ),
                  const SizedBox(
                    height: AppDimens.vSpace32,
                  ), // Espacio antes del BottomNavBar
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoaded) {
              return Padding(
                padding: const EdgeInsets.all(AppDimens.screenPadding),
                child: core_widgets.PrimaryButton(
                  label:
                      '\$${(state.product.price * state.quantity).toStringAsFixed(2)}    ${AppStrings.addToBagLabel}',
                  onPressed: () {
                    // TODO: Implementar AddToCart event y lógica en BLoC
                    // context.read<ProductDetailBloc>().add(ProductAddToCartRequested());
                    print(
                      'Añadido al carrito: ${state.product.name}, Talla: ${state.selectedSize}, Color: ${state.selectedColor.name}, Cantidad: ${state.quantity}',
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
  }
}
