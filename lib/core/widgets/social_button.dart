import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

/// Un botón reutilizable para acciones de inicio de sesión con redes sociales u otros proveedores.
///
/// Muestra un icono (SVG o PNG) a la izquierda y una etiqueta de texto centrada.
class SocialButton extends StatelessWidget {
  /// Ruta del asset para el icono (SVG o PNG).
  final String assetPath;
  
  /// Texto que se muestra en el botón.
  final String label;
  
  /// Callback que se ejecuta cuando el botón es presionado.
  final VoidCallback onPressed;

  /// Crea una instancia de [SocialButton].
  const SocialButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determina si el asset es un SVG para usar el widget apropiado.
    final bool isSvg = assetPath.toLowerCase().endsWith('.svg');

    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      height: AppDimens.buttonHeight, // Altura estándar de botón
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.socialBackground,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.socialButtonPaddingVertical),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
          side: BorderSide.none, // Sin borde visible para el OutlinedButton
        ),
        child: Stack(
          alignment: Alignment.center, // Centra el texto por defecto
          children: [
            // Icono alineado a la izquierda
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimens.socialButtonIconLeft),
                child: isSvg
                    ? SvgPicture.asset(
                        assetPath,
                        width: AppDimens.iconSize,
                        height: AppDimens.iconSize,
                      )
                    : Image.asset(
                        assetPath,
                        width: AppDimens.iconSize,
                        height: AppDimens.iconSize,
                      ),
              ),
            ),
            // Texto del botón
            Text(label, style: AppTextStyles.socialButton),
          ],
        ),
      ),
    );
  }
}
