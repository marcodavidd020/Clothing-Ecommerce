import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Widget que aplica un efecto de desvanecimiento en el borde inferior
/// para contenido scrollable, indicando que hay más contenido
class FadeEdgeScrollWidget extends StatefulWidget {
  /// Widget hijo que será desplazable
  final Widget child;

  /// Controller para controlar el scroll
  final ScrollController scrollController;

  /// Si el efecto de desvanecimiento debe mostrarse
  final bool enableFadeEffect;

  /// Constructor
  const FadeEdgeScrollWidget({
    super.key,
    required this.child,
    required this.scrollController,
    this.enableFadeEffect = true,
  });

  @override
  State<FadeEdgeScrollWidget> createState() => _FadeEdgeScrollWidgetState();
}

class _FadeEdgeScrollWidgetState extends State<FadeEdgeScrollWidget> {
  /// Controla si se debe mostrar el efecto fade en el borde inferior
  bool _showFade = true;

  @override
  void initState() {
    super.initState();
    if (widget.enableFadeEffect) {
      widget.scrollController.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    if (widget.enableFadeEffect) {
      widget.scrollController.removeListener(_scrollListener);
    }
    super.dispose();
  }

  /// Controla cuando mostrar/ocultar el efecto de desvanecimiento
  void _scrollListener() {
    const double scrollThreshold = 10.0;
    bool isAtBottom =
        widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - scrollThreshold;

    if (isAtBottom && _showFade) {
      setState(() => _showFade = false);
    } else if (!isAtBottom && !_showFade) {
      setState(() => _showFade = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableFadeEffect) {
      return widget.child;
    }

    return ShaderMask(
      shaderCallback: _buildShaderCallback,
      blendMode: BlendMode.dstIn,
      child: widget.child,
    );
  }

  /// Crea el shader para el efecto de desvanecimiento
  Shader _buildShaderCallback(Rect bounds) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors:
          _showFade
              ? [Colors.white, Colors.white.withAlpha(0)]
              : [Colors.white, Colors.white],
      stops:
          _showFade
              ? const [
                AppDimens.homeContentFadeStart,
                AppDimens.homeContentFadeEnd,
              ]
              : null,
    ).createShader(bounds);
  }
}
