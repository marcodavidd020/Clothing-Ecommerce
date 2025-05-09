import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

/// Widget que muestra una imagen de red con un efecto de redacción mientras carga.
class NetworkImageWithPlaceholder extends StatefulWidget {
  /// URL de la imagen a cargar.
  final String imageUrl;

  /// Ancho de la imagen.
  final double? width;

  /// Alto de la imagen.
  final double? height;

  /// Cómo ajustar la imagen dentro del espacio disponible.
  final BoxFit fit;

  /// Forma de la imagen.
  final BoxShape shape;

  /// Crea una instancia de [NetworkImageWithPlaceholder].
  const NetworkImageWithPlaceholder({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
  });

  @override
  State<NetworkImageWithPlaceholder> createState() =>
      _NetworkImageWithPlaceholderState();
}

class _NetworkImageWithPlaceholderState
    extends State<NetworkImageWithPlaceholder> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(shape: widget.shape, color: Colors.grey[300]),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder redactado mientras carga
          Container(
            color: Colors.grey[300],
          ).redacted(context: context, redact: _isLoading),

          // Imagen real
          Image.network(
            widget.imageUrl,
            fit: widget.fit,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                if (_isLoading) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                }
                return child;
              }
              return const SizedBox.shrink();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const SizedBox.shrink();
            },
            errorBuilder: (context, error, stackTrace) {
              setState(() {
                _isLoading = false;
              });
              return const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }
}
