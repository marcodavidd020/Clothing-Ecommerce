import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

/// Un widget que anima la aparición de una lista de widgets hijos de forma escalonada
/// y opcionalmente los muestra como "redactados" mientras se animan.
class AnimatedStaggeredList extends StatefulWidget {
  /// La lista de widgets que se animarán.
  final List<Widget> children;

  /// La duración total para que todos los elementos completen su animación de entrada.
  final Duration staggerDuration;

  /// El retraso individual entre la aparición de cada elemento consecutivo.
  final Duration itemDelay;

  /// El desplazamiento vertical inicial para la animación de deslizamiento (0.0 a 1.0).
  /// 0.5 significa que el widget comienza un 50% de su altura por debajo de su posición final.
  final double initialOffsetY;

  /// Indica si el widget debe comenzar redactado.
  final bool initiallyRedacted;

  /// Crea una instancia de [AnimatedStaggeredList].
  const AnimatedStaggeredList({
    super.key,
    required this.children,
    this.staggerDuration = const Duration(
      milliseconds: 700,
    ), // Duración total por defecto
    this.itemDelay = const Duration(
      milliseconds: 150,
    ), // Retraso entre items por defecto
    this.initialOffsetY = 0.2, // Desplazamiento vertical inicial más sutil
    this.initiallyRedacted = true, // Por defecto, comienza redactado
  });

  @override
  State<AnimatedStaggeredList> createState() => _AnimatedStaggeredListState();
}

class _AnimatedStaggeredListState extends State<AnimatedStaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];
  bool _isRedacted = true;

  @override
  void initState() {
    super.initState();
    _isRedacted = widget.initiallyRedacted;

    _animationController = AnimationController(
      duration: widget.staggerDuration,
      vsync: this,
    );

    // Calcula la duración de la animación para cada item y el intervalo de inicio
    final double totalItems = widget.children.length.toDouble();
    final double singleItemAnimationProportion =
        totalItems > 0 ? 1.0 / totalItems : 1.0;
    final double delayProportion =
        widget.staggerDuration.inMilliseconds > 0
            ? widget.itemDelay.inMilliseconds / widget.staggerDuration.inMilliseconds
            : 0;

    for (int i = 0; i < widget.children.length; i++) {
      // El inicio de la animación para este item se basa en su índice y el itemDelay
      final double startTime = (i * delayProportion).clamp(
          0.0,
          1.0 - singleItemAnimationProportion);
      // El final de la animación asegura que cada item tenga suficiente tiempo para animarse completamente
      final double endTime = (startTime + singleItemAnimationProportion * 2)
          .clamp(startTime, 1.0); // Ajustado para mejor visibilidad

      _slideAnimations.add(
        Tween<Offset>(
          begin: Offset(0, widget.initialOffsetY),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
          ),
        ),
      );
      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(startTime, endTime, curve: Curves.easeIn),
          ),
        ),
      );
    }

    _animationController.forward();

    // Quitar redacción después de que la animación principal haya tenido tiempo de empezar
    // o un poco antes de que termine, para que el contenido real aparezca suavemente.
    if (widget.initiallyRedacted) {
      Future.delayed(widget.staggerDuration - widget.itemDelay, () { // Ajustar este delay según se vea mejor
        if (mounted) {
          setState(() {
            _isRedacted = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.children.length, (index) {
        Widget child = widget.children[index];
        if (_isRedacted) {
          // Aplicar la redacción. El paquete espera que el contexto se pase.
          // El paquete `redacted` parece usar una extensión, así que lo aplicamos así.
          child = child.redacted(context: context, redact: true);
        }
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: child,
          ),
        );
      }),
    ).redacted(context: context, redact: _isRedacted); // Redacta el Column entero si aún se está cargando
  }
}
