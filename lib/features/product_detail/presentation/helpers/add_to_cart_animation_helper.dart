import 'package:flutter/material.dart';

/// Helper class for creating animations when adding products to cart.
class AddToCartAnimationHelper {
  /// Creates a flying animation from the source widget to the cart icon.
  ///
  /// [context] - The build context
  /// [sourceKey] - GlobalKey of the source widget (product image)
  /// [targetKey] - GlobalKey of the target widget (cart icon/button)
  /// [imageUrl] - URL of the product image to animate
  /// [onComplete] - Callback function when animation completes
  static void runAddToCartAnimation({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    required String imageUrl,
    required VoidCallback onComplete,
  }) {
    // Verificar que el contexto siga montado
    if (!context.mounted) {
      onComplete();
      return;
    }

    try {
      // Get the positions and sizes of the source and target widgets
      final RenderBox? sourceBox =
          sourceKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? targetBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;

      if (sourceBox == null || targetBox == null) {
        // If either box is null, just call onComplete and return
        onComplete();
        return;
      }

      // Get the positions in the coordinate system of the overall overlay
      final Offset sourcePosition = sourceBox.localToGlobal(Offset.zero);
      final Offset targetPosition = targetBox.localToGlobal(Offset.zero);

      // Create a variable for the entry first
      late final OverlayEntry entry;

      // Define the entry with its builder function
      entry = OverlayEntry(
        builder:
            (context) => DirectShrinkAnimation(
              sourcePosition: sourcePosition,
              sourceSize: sourceBox.size,
              targetPosition: targetPosition,
              targetSize: targetBox.size,
              imageUrl: imageUrl,
              onComplete: () {
                try {
                  // Remove the overlay entry when animation completes
                  entry.remove();
                } catch (e) {
                  // Si hay un error al remover la entrada, ignorarlo
                  debugPrint('Error al remover overlay: $e');
                } finally {
                  // Asegurar que onComplete siempre se llame
                  onComplete();
                }
              },
            ),
      );

      // Insert the overlay entry
      Overlay.of(context).insert(entry);
    } catch (e) {
      // Si ocurre cualquier error, simplemente continuar con la acción
      debugPrint('Error durante la animación: $e');
      onComplete();
    }
  }
}

/// Widget that animates a direct shrinking motion from source to target.
class DirectShrinkAnimation extends StatefulWidget {
  final Offset sourcePosition;
  final Size sourceSize;
  final Offset targetPosition;
  final Size targetSize;
  final String imageUrl;
  final VoidCallback onComplete;

  const DirectShrinkAnimation({
    Key? key,
    required this.sourcePosition,
    required this.sourceSize,
    required this.targetPosition,
    required this.targetSize,
    required this.imageUrl,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<DirectShrinkAnimation> createState() => _DirectShrinkAnimationState();
}

class _DirectShrinkAnimationState extends State<DirectShrinkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animación de tamaño - de tamaño original a pequeño
    _sizeAnimation = Tween<double>(
      begin: widget.sourceSize.width,
      end: widget.targetSize.width * 0.8,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    // Posición - del centro de la imagen al centro del carrito
    _positionAnimation = Tween<Offset>(
      begin: Offset(
        widget.sourcePosition.dx + widget.sourceSize.width / 2,
        widget.sourcePosition.dy + widget.sourceSize.height / 2,
      ),
      end: Offset(
        widget.targetPosition.dx + widget.targetSize.width / 2,
        widget.targetPosition.dy + widget.targetSize.height / 2,
      ),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    // Opacidad - de visible a casi invisible al final
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Rotación - un poco de rotación para hacerlo más natural
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    _controller.forward().whenComplete(() {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos directamente un Image.network para preservar la transparencia del PNG
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final size = _sizeAnimation.value;

        return Positioned(
          left: _positionAnimation.value.dx - size / 2,
          top: _positionAnimation.value.dy - size / 2,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SizedBox(
                width: size,
                height: size,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  // Forzar que la imagen se renderice sin fondo
                  color: Colors.white.withOpacity(0.99),
                  colorBlendMode: BlendMode.dstIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Función de interpolación lineal para animar valores
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
