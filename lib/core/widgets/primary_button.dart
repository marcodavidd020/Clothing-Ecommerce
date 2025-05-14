import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

/// Un botón primario reutilizable con estilos consistentes.
///
/// Ofrece la opción de un fondo con color sólido (por defecto) o un degradado.
class PrimaryButton extends StatelessWidget {
  /// Texto que se muestra en el botón.
  final String label;

  /// Callback que se ejecuta cuando el botón es presionado.
  final VoidCallback? onPressed; // Hacer onPressed nullable cuando está deshabilitado

  /// Altura del botón. Por defecto es [AppDimens.buttonHeight].
  final double height;

  /// Si es `true`, el botón tendrá un fondo con degradado.
  /// Si es `false` (por defecto), usará [AppColors.primary] como color de fondo.
  final bool gradient;

  /// Si es `true`, el botón se muestra en estado de carga (deshabilitado).
  final bool isLoading;

  /// Crea una instancia de [PrimaryButton].
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height =
        AppDimens.buttonHeight, // Usar constante para altura por defecto
    this.gradient = false,
    this.isLoading = false, // Añadir parámetro isLoading, por defecto false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // El botón ocupa todo el ancho disponible
      height: height,
      decoration: BoxDecoration(
        color: gradient ? null : AppColors.primary,
        gradient:
            gradient
                ? const LinearGradient(
                  // Colores específicos para el degradado, podrían ser constantes también
                  colors: [Color(0xFF8A2BE2), Color(0xFFDA22FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                : null,
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        // Opcional: añadir un efecto visual de deshabilitado si no se usa onPressed = null
        // color: isLoading ? Colors.grey : (gradient ? null : AppColors.primary),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Deshabilitar si isLoading es true
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // El color lo da el Container
          shadowColor: Colors.transparent, // Sin sombra propia
          padding: EdgeInsets.zero, // Padding controlado por el Container
          minimumSize: const Size(
            double.infinity,
            double.infinity,
          ), // Ocupa todo el espacio del Container
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
