import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar flutter_bloc
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart'; // Usaremos el modelo de producto de home
import 'package:flutter_application_ecommerce/features/product_detail/presentation/widgets/widgets.dart'; // Importar widgets
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart'; // Importar el BLoC
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart'; // Importar bloc del carrito
import 'package:flutter_application_ecommerce/features/product_detail/presentation/helpers/helpers.dart';

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

  @override
  void initState() {
    super.initState();
    // La carga del producto se maneja en BlocProvider.create
  }

  /// Ejecuta la animación de añadir al carrito y luego llama a la función real de añadir al carrito
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
    // Obtener CartBloc existente o null si no se encuentra
    final cartBloc = CartIntegrationHelper.getExistingCartBloc(context);

    // Crear contenido de detalle de producto con BlocProvider
    Widget productDetailContent = BlocProvider(
      create: (context) => ProductDetailBloc(cartBloc: cartBloc)
        ..add(ProductDetailLoadRequested(product: widget.product)),
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


