import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/cart/core/core.dart';
import 'package:flutter_application_ecommerce/features/cart/domain/domain.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';

/// Page that displays the products in the shopping cart.
class CartPage extends StatefulWidget {
  /// Creates an instance of [CartPage].
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Cargar el carrito cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCart();
    });
  }

  /// Carga el carrito desde la API
  void _loadCart() {
    AppLogger.logInfo('=== CARGANDO CARRITO DESDE CART PAGE ===');
    final cartBloc = context.read<CartBloc>();

    // Verificar si el carrito ya está cargado
    if (cartBloc.state is! CartLoaded) {
      AppLogger.logInfo(
        'Estado actual del carrito: ${cartBloc.state.runtimeType}',
      );
      cartBloc.add(const CartLoadRequested());
    } else {
      AppLogger.logInfo(
        'Carrito ya está cargado con ${(cartBloc.state as CartLoaded).items.length} items',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Construye la AppBar con el botón de vaciar carrito
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      titleText: CartStrings.cartTitle,
      showBack: true,
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded && !state.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: AppDimens.appBarActionRightPadding,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: AppColors.error,
                    ),
                    onPressed: () => _showClearCartDialog(),
                    tooltip: CartStrings.removeAllButtonTooltip,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Construye el cuerpo principal de la página
  Widget _buildBody() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        AppLogger.logInfo('Estado actual del CartBloc: ${state.runtimeType}');

        if (state is CartInitial || state is CartLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppDimens.vSpace16),
                Text('Cargando carrito...'),
              ],
            ),
          );
        }

        if (state is CartError) {
          AppLogger.logError('Error en CartPage: ${state.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: AppDimens.vSpace16),
                Text(
                  'Error al cargar el carrito',
                  style: AppTextStyles.heading.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: AppDimens.vSpace8),
                Text(
                  state.message,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.vSpace16),
                ElevatedButton(
                  onPressed: _loadCart,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is CartLoaded) {
          AppLogger.logInfo('Carrito cargado con ${state.items.length} items');

          if (state.isEmpty) {
            return const EmptyCartWidget();
          }

          return CartItemListWidget(
            state: state,
            onDeleteConfirmation: _showDeleteConfirmation,
            onQuantityChanged: _onQuantityChanged,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Construye la barra inferior con el resumen y botón de checkout
  Widget _buildBottomNavBar() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded && !state.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppDimens.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CartSummaryWidget(state: state),
                const SizedBox(height: AppDimens.vSpace16),
                PrimaryButton(
                  label:
                      '${CartStrings.checkoutButtonLabel}\$${state.totalPrice.toStringAsFixed(2)}',
                  onPressed: _onCheckoutPressed,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Maneja la confirmación de eliminar un item del carrito
  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    CartItemModel item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmDialogWidget(
          title: CartStrings.removeItemTitle,
          message: CartStrings.removeItemMessage.replaceAll(
            '%s',
            item.product.name,
          ),
          cancelText: CartStrings.cancelButtonLabel,
          confirmText: CartStrings.removeButtonLabel,
          icon: Icons.delete_outlined,
          accentColor: AppColors.error,
        );
      },
    );

    if (result == true && mounted) {
      AppLogger.logInfo('Eliminando item del carrito: ${item.product.name}');
      final cartBloc = context.read<CartBloc>();
      
      // Usar API si está disponible y el item tiene ID de API, sino usar método local
      if (cartBloc.removeCartItemUseCase != null && item.apiItemId != null) {
        AppLogger.logInfo('Usando API para eliminar item: ${item.apiItemId}');
        cartBloc.add(CartItemRemovedFromApi(apiItemId: item.apiItemId!));
      } else {
        AppLogger.logInfo('Usando método local para eliminar item: ${item.id}');
        cartBloc.add(CartItemRemoved(itemId: item.id));
      }
      return true;
    }

    return false;
  }

  /// Maneja el cambio de cantidad de un item
  void _onQuantityChanged(
    BuildContext context,
    CartItemModel item,
    int newQuantity,
  ) {
    if (newQuantity <= 0) {
      _showDeleteConfirmation(context, item);
    } else {
      AppLogger.logInfo(
        'Actualizando cantidad de ${item.product.name} a $newQuantity',
      );
      final cartBloc = context.read<CartBloc>();
      
      // Usar API si está disponible y el item tiene ID de API, sino usar método local
      if (cartBloc.updateCartItemUseCase != null && item.apiItemId != null) {
        AppLogger.logInfo('Usando API para actualizar cantidad: ${item.apiItemId}');
        cartBloc.add(CartItemQuantityUpdatedInApi(
          apiItemId: item.apiItemId!,
          newQuantity: newQuantity,
        ));
      } else {
        AppLogger.logInfo('Usando método local para actualizar cantidad: ${item.id}');
        cartBloc.add(CartItemQuantityUpdated(
          itemId: item.id,
          newQuantity: newQuantity,
        ));
      }
    }
  }

  /// Muestra el diálogo de confirmación para vaciar el carrito
  Future<void> _showClearCartDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmDialogWidget(
          title: CartStrings.clearCartTitle,
          message: CartStrings.clearCartMessage,
          cancelText: CartStrings.cancelButtonLabel,
          confirmText: CartStrings.clearAllButtonLabel,
          icon: Icons.remove_shopping_cart_outlined,
          accentColor: AppColors.error,
        );
      },
    );

    if (result == true && mounted) {
      AppLogger.logInfo('Vaciando carrito completo');
      final cartBloc = context.read<CartBloc>();
      
      // Usar API si está disponible, sino usar método local
      if (cartBloc.clearCartUseCase != null) {
        AppLogger.logInfo('Usando API para vaciar carrito');
        cartBloc.add(const CartClearedFromApi());
      } else {
        AppLogger.logInfo('Usando método local para vaciar carrito');
        cartBloc.add(const CartCleared());
      }
    }
  }

  /// Maneja el botón de checkout
  void _onCheckoutPressed() {
    AppRouter.pushCheckout(context);
  }
}
