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
  LoadState _loadState = LoadState.loading;

  @override
  void initState() {
    super.initState();
    // Si la URL está vacía, marcar como error inmediatamente.
    if (widget.imageUrl.isEmpty) {
      _loadState = LoadState.error;
    }
  }

  @override
  void didUpdateWidget(NetworkImageWithPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      // Si la URL de la imagen cambia, reiniciar el estado de carga.
      _loadState = widget.imageUrl.isEmpty ? LoadState.error : LoadState.loading;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: widget.shape,
        color: Colors.grey[200], // Un color de fondo base
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
                size: (widget.width ?? widget.height ?? 50) * 0.5, // Tamaño relativo del icono
              ),
            ),

          // Imagen real (solo se intenta cargar si no hay error pre-detectado)
          if (_loadState != LoadState.error)
            Image.network(
              widget.imageUrl,
              fit: widget.fit,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  // Si se carga síncronamente (ej. desde caché), puede que el estado de carga necesite actualizarse aquí mismo.
                  // Pero es más seguro hacerlo después del build con Future.delayed.
                  if (_loadState == LoadState.loading) {
                     WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                           setState(() {
                            _loadState = LoadState.loaded;
                           });
                        }
                     });
                  }
                  return child;
                }
                if (frame != null) {
                  // La imagen se ha cargado y tiene al menos un frame
                  if (_loadState == LoadState.loading) {
                    // Usamos addPostFrameCallback para asegurar que setState se llama después del build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _loadState = LoadState.loaded;
                        });
                      }
                    });
                  }
                  return child;
                }
                // Aún cargando (frame es null y no fue síncrono)
                return const SizedBox.shrink(); // No mostrar nada mientras carga si no es el placeholder
              },
              loadingBuilder: (context, child, loadingProgress) {
                // Este builder es más simple, frameBuilder es más robusto para el estado.
                // Si loadingProgress es null, la imagen está cargada (o hubo error que maneja errorBuilder).
                if (loadingProgress == null) {
                  return child; // Devuelve el child (Image) o el errorBuilder lo manejará
                }
                // Aún cargando, el placeholder de redactado ya está visible.
                return const SizedBox.shrink();
              },
              errorBuilder: (context, error, stackTrace) {
                // Si ocurre un error durante la carga de la red.
                if (_loadState != LoadState.error) {
                  // Usamos addPostFrameCallback para asegurar que setState se llama después del build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                     if (mounted) {
                       setState(() {
                         _loadState = LoadState.error;
                       });
                     }
                  });
                }
                // Ya no se muestra el placeholder de error aquí directamente,
                // el Stack lo manejará basado en _loadState.
                return const SizedBox.shrink(); 
              },
            ),
        ],
      ),
    );
  }
}

// Enum para gestionar los estados de carga de la imagen
enum LoadState {
  loading,
  loaded,
  error,
}
