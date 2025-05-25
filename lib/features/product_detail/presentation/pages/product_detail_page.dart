import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar flutter_bloc
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart'; // Usaremos el modelo de producto de home
import 'package:flutter_application_ecommerce/features/home/data/models/product_detail_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/states/product_states.dart'
    as home_states;
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart'; // Importar widgets
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart'
    as product_detail_bloc;
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart'; // Importar bloc del carrito
import 'package:flutter_application_ecommerce/features/product_detail/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

/// Página que muestra los detalles de un producto.
class ProductDetailPage extends StatefulWidget {
  /// El producto para mostrar los detalles.
  final ProductItemModel product;

  /// Crea una instancia de [ProductDetailPage].
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Keys para animación
  final GlobalKey _currentImageKey = GlobalKey();
  final GlobalKey _cartButtonKey = GlobalKey();
  final GlobalKey _carouselKey = GlobalKey();

  // Estado para controlar la visibilidad de la imagen durante la animación
  bool _imageVisibleInCarousel = true;

  // Estado del detalle del producto
  ProductDetailModel? _productDetail;
  bool _isLoadingDetail = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductDetail();
  }

  /// Carga el detalle completo del producto desde la API
  void _loadProductDetail() {
    AppLogger.logInfo('Cargando detalle del producto: ${widget.product.id}');

    // Disparar evento para cargar el detalle del producto
    context.read<HomeBloc>().add(
      LoadProductByIdEvent(productId: widget.product.id),
    );
  }

  /// Ejecuta la animación de añadir al carrito y luego llama a la función real de añadir al carrito
  void _animateAddToCart(product_detail_bloc.ProductDetailLoaded state) {
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
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is home_states.ProductDetailLoaded) {
          AppLogger.logSuccess(
            'Detalle del producto cargado: ${state.product.name}',
          );
          setState(() {
            _productDetail = state.product;
            _isLoadingDetail = false;
            _errorMessage = null;
          });
        } else if (state is HomeError) {
          AppLogger.logError(
            'Error al cargar detalle del producto: ${state.message}',
          );
          setState(() {
            _isLoadingDetail = false;
            _errorMessage = state.message;
          });
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoadingDetail) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.product.name)),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando detalles del producto...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.product.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_errorMessage'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProductDetail,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Obtener CartBloc existente o null si no se encuentra
    final cartBloc = CartIntegrationHelper.getExistingCartBloc(context);

    // Crear contenido de detalle de producto con BlocProvider
    Widget productDetailContent = BlocProvider(
      create:
          (context) => product_detail_bloc.ProductDetailBloc(
            cartBloc: cartBloc,
            productDetail: _productDetail, // Pasar el detalle completo
          )..add(
            product_detail_bloc.ProductDetailLoadRequested(
              product: widget.product,
            ),
          ),
      child: Builder(
        // Añadimos un Builder para tener acceso al context con el provider
        builder: (builderContext) {
          return ProductDetailScaffoldWidget(
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

    // Envolver con CartBloc si no se encuentra en el árbol
    if (cartBloc == null) {
      return BlocProvider(
        create: (context) => CartBloc()..add(const CartLoadRequested()),
        child: productDetailContent,
      );
    }

    // Si CartBloc está disponible, solo devolver el contenido
    return productDetailContent;
  }
}
