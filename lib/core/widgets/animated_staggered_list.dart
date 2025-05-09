import 'package:flutter/material.dart';

/// Un widget que anima la aparición de una lista de widgets hijos de forma escalonada.
///
/// Cada hijo entra con una animación de deslizamiento desde abajo y un fundido de opacidad.
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
  });

  @override
  State<AnimatedStaggeredList> createState() => _AnimatedStaggeredListState();
}

class _AnimatedStaggeredListState extends State<AnimatedStaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.staggerDuration,
      vsync: this,
    );

    // Calcula la duración de la animación para cada item y el intervalo de inicio
    final double totalItems = widget.children.length.toDouble();
    final double singleItemAnimationProportion =
        1.0 / totalItems; // Proporción de la duración total por item
    final double delayProportion =
        widget.itemDelay.inMilliseconds / widget.staggerDuration.inMilliseconds;

    for (int i = 0; i < widget.children.length; i++) {
      // El inicio de la animación para este item se basa en su índice y el itemDelay
      final double startTime = (i * delayProportion).clamp(
        0.0,
        1.0 - singleItemAnimationProportion,
      );
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
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
