import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';
import '../helpers/navigation_helper.dart';
import 'widgets.dart';

/// Un widget de [AppBar] personalizado y reutilizable para la aplicación.
///
/// Ofrece opciones para mostrar/ocultar un botón de retroceso, un título personalizado,
/// un botón de bolsa de compras y una imagen de perfil de usuario.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Determina si se muestra el botón de retroceso.
  /// Por defecto es `false` si se muestra una imagen de perfil, o `true` en otros contextos de página.
  final bool showBack;

  /// Callback que se ejecuta cuando se presiona el botón de retroceso.
  /// Si es nulo y [showBack] es true, se usará `NavigationHelper.goBack(context)`.
  final VoidCallback? onBack;

  /// Widget opcional para mostrar como título, centrado en el AppBar.
  final Widget? title;

  /// Texto opcional para mostrar como título. Si se provee `title` (Widget), este será ignorado.
  final String? titleText;

  /// Callback opcional para el evento de presionar el botón de la bolsa de compras.
  /// Si es provisto, se muestra el icono de la bolsa.
  final VoidCallback? onBagPressed;

  /// URL o ruta local de la imagen de perfil del usuario.
  /// Si se provee junto con [onProfilePressed], se muestra un [CircleAvatar] a la izquierda.
  final String? profileImageUrl;

  /// Callback opcional para el evento de presionar la imagen de perfil.
  final VoidCallback? onProfilePressed;

  /// Una lista opcional de widgets para mostrar después del [title] (o [titleText]).
  final List<Widget>? actions;

  /// Controla el espaciado alrededor del título
  final double titleSpacing;

  /// Establece la altura de la barra de herramientas
  final double toolbarHeight;

  /// Crea una instancia de [CustomAppBar].
  const CustomAppBar({
    super.key,
    this.showBack = false,
    this.onBack,
    this.title,
    this.titleText,
    this.onBagPressed,
    this.profileImageUrl,
    this.onProfilePressed,
    this.actions,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    // Determina el widget a mostrar en la posición 'leading' (izquierda).
    // Prioridad: Imagen de perfil > Botón de retroceso > Espacio vacío.
    if (profileImageUrl != null && onProfilePressed != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: AppDimens.screenPadding),
        child: Center(
          child: GestureDetector(
            onTap: onProfilePressed,
            child: SizedBox(
              width: AppDimens.backButtonSize,
              height: AppDimens.backButtonSize,
              child: NetworkImageWithPlaceholder.isValidImageUrl(profileImageUrl!)
                  ? NetworkImageWithPlaceholder(
                      imageUrl: profileImageUrl!,
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                    )
                  : CircleAvatar(
                      radius: AppDimens.backButtonSize / 2.2,
                      backgroundImage: AssetImage(AppStrings.userPlaceholderIcon),
                    ),
            ),
          ),
        ),
      );
    } else if (showBack) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: AppDimens.screenPadding),
        child: GestureDetector(
          onTap: onBack ?? () => NavigationHelper.goBack(context),
          child: Container(
            width: AppDimens.backButtonSize,
            height: AppDimens.backButtonSize,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppStrings.backIcon,
                width: AppDimens.backIconSize,
                height: AppDimens.backIconSize,
              ),
            ),
          ),
        ),
      );
    } else {
      // Si no hay perfil ni botón de back, se asegura un espaciado consistente.
      leadingWidget = SizedBox(
        width: AppDimens.screenPadding + AppDimens.backButtonSize,
      );
    }

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      title:
          title ??
          (titleText != null
              ? Text(
                titleText!,
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              )
              : null),
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      leading: leadingWidget,
      leadingWidth:
          AppDimens.screenPadding +
          AppDimens.backButtonSize, // Ancho consistente para el leading
      actions: _buildActions(
        context,
      ), // Usar un método helper para construir las acciones
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    List<Widget> effectiveActions = [];

    // Añadir las acciones personalizadas proporcionadas
    if (actions != null) {
      effectiveActions.addAll(actions!);
    }

    // Añadir el botón de la bolsa si está configurado y no hay acciones personalizadas que lo reemplacen
    // o si queremos que siempre esté presente además de otras acciones.
    // Por ahora, si se proveen `actions`, estas tienen precedencia.
    // Si se desea que el botón de la bolsa coexista, se puede ajustar esta lógica.
    if (onBagPressed != null && (actions == null || actions!.isEmpty)) {
      effectiveActions.add(
        Padding(
          padding: const EdgeInsets.only(right: AppDimens.screenPadding),
          child: GestureDetector(
            onTap: onBagPressed,
            child: Container(
              width: AppDimens.backButtonSize,
              height: AppDimens.backButtonSize,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppStrings.bagIcon,
                  width: AppDimens.iconSize,
                  height: AppDimens.iconSize,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // else if (onBagPressed != null && actions != null && actions!.isNotEmpty) {
    //   // Lógica para añadir el botón de la bolsa AL FINAL de las acciones personalizadas
    //   effectiveActions.add(Padding( /* ... widget del botón de la bolsa ... */ ));
    // }

    return effectiveActions.isNotEmpty ? effectiveActions : null;
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
