import 'dart:async';
import 'package:flutter/material.dart';

/// Widget que previene múltiples clics en un corto período de tiempo.
///
/// Este widget es útil para evitar navegaciones duplicadas o múltiples llamadas
/// a APIs cuando un usuario hace clic repetidamente en un botón.
class DebounceButton extends StatefulWidget {
  /// El widget hijo que será envuelto con la protección anti-rebote
  final Widget child;

  /// La función a ejecutar cuando se presione el botón
  final VoidCallback onPressed;

  /// El tiempo de espera en milisegundos antes de permitir otro clic
  /// Por defecto es 500ms
  final int debounceTime;

  /// Crea un [DebounceButton] con los parámetros especificados.
  ///
  /// El [child] es el widget que se mostrará como botón.
  /// [onPressed] es la función que se ejecutará cuando se presione el botón.
  /// [debounceTime] es el tiempo en milisegundos que debe pasar antes de
  /// permitir otro clic (por defecto 500ms).
  const DebounceButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.debounceTime = 500,
  }) : super(key: key);

  @override
  State<DebounceButton> createState() => _DebounceButtonState();
}

class _DebounceButtonState extends State<DebounceButton> {
  /// Indica si el botón está habilitado para recibir clics
  bool _isEnabled = true;

  /// Timer para controlar el tiempo de espera entre clics
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Maneja el clic en el botón con protección anti-rebote
  void _handleTap() {
    if (_isEnabled) {
      // Deshabilitar el botón temporalmente
      setState(() {
        _isEnabled = false;
      });

      // Ejecutar la función de clic
      widget.onPressed();

      // Iniciar temporizador para volver a habilitar el botón
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: widget.debounceTime), () {
        if (mounted) {
          setState(() {
            _isEnabled = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
