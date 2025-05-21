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

  /// Si el fondo es transparente.
  final bool transparent;

  /// Lista de dominios problemáticos que siempre deben tratarse como errores
  static const List<String> _problematicDomains = [
    'cdn.tienda.com',
    'localhost',
    '127.0.0.1',
  ];

  /// Verifica si una URL es válida y no proviene de un dominio problemático
  static bool isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    if (!url.startsWith('http://') && !url.startsWith('https://')) return false;
    
    // Verificar si la URL contiene algún dominio problemático
    for (final domain in _problematicDomains) {
      if (url.contains(domain)) return false;
    }
    
    return true;
  }

  /// Crea una instancia de [NetworkImageWithPlaceholder].
  const NetworkImageWithPlaceholder({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    // Fondo transparente boolean
    this.transparent = false,
  });

  @override
  State<NetworkImageWithPlaceholder> createState() =>
      _NetworkImageWithPlaceholderState();
}

class _NetworkImageWithPlaceholderState
    extends State<NetworkImageWithPlaceholder> {
  LoadState _loadState = LoadState.loading;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    // Verificar inmediatamente si la URL es válida
    if (!NetworkImageWithPlaceholder.isValidImageUrl(widget.imageUrl)) {
      _loadState = LoadState.error;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void didUpdateWidget(NetworkImageWithPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      // Si la URL cambió, validarla y actualizar el estado
      _loadState = NetworkImageWithPlaceholder.isValidImageUrl(widget.imageUrl) 
          ? LoadState.loading 
          : LoadState.error;
    }
  }

  // Actualiza el estado de forma segura verificando si el widget sigue montado
  void _safeSetState(Function() callback) {
    if (!_disposed && mounted) {
      setState(callback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: widget.shape,
        color:
            widget.transparent
                ? Colors.transparent
                : Colors.grey[200], // Un color de fondo base
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder de carga (efecto redactado)
          if (_loadState == LoadState.loading)
            Container(
              color: Colors.grey[300],
            ).redacted(context: context, redact: true),

          // Placeholder de error
          if (_loadState == LoadState.error)
            Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey[400],
                size:
                    (widget.width ?? widget.height ?? 50) *
                    0.5, // Tamaño relativo del icono
              ),
            ),

          // Imagen real (solo se intenta cargar si no hay error pre-detectado)
          if (_loadState != LoadState.error && NetworkImageWithPlaceholder.isValidImageUrl(widget.imageUrl))
            Image.network(
              widget.imageUrl,
              fit: widget.fit,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null || wasSynchronouslyLoaded) {
                  // La imagen se ha cargado exitosamente
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _safeSetState(() {
                      _loadState = LoadState.loaded;
                    });
                  });
                  return child;
                }
                // Aún cargando
                return const SizedBox.shrink();
              },
              errorBuilder: (context, error, stackTrace) {
                // Error al cargar la imagen
                debugPrint('Error al cargar imagen: ${widget.imageUrl} - $error');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _safeSetState(() {
                    _loadState = LoadState.error;
                  });
                });
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}

// Enum para gestionar los estados de carga de la imagen
enum LoadState { loading, loaded, error }
