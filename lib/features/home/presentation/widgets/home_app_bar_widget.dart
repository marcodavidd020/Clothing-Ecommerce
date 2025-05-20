import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category_selector_widget.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

/// Widget que implementa el AppBar personalizado para la página Home.
///
/// Incluye el selector de categorías, botón de perfil y botón de carrito con contador.
class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Lista de categorías principales para mostrar
  final List<CategoryApiModel> rootCategories;

  /// Categoría seleccionada actualmente
  final CategoryApiModel? selectedCategory;

  /// Callback cuando se selecciona una categoría
  final Function(CategoryApiModel)? onCategorySelected;

  /// Callback cuando se quiere mostrar el selector de categorías
  final VoidCallback? onCategoryDisplay;

  /// Callback cuando se presiona el botón de carrito
  final VoidCallback onBagPressed;

  /// Callback cuando se presiona el botón de perfil
  final VoidCallback onProfilePressed;

  /// URL de la imagen de perfil (puede ser un recurso local o remoto)
  final String profileImageUrl;

  /// Constructor principal
  const HomeAppBarWidget({
    super.key,
    this.rootCategories = const [],
    this.selectedCategory,
    this.onCategorySelected,
    this.onCategoryDisplay,
    required this.onBagPressed,
    required this.onProfilePressed,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      showBack: false,
      onBagPressed: onBagPressed,
      profileImageUrl: profileImageUrl,
      onProfilePressed: onProfilePressed,
      title: _buildCategorySelector(),
      titleSpacing: 0,
      toolbarHeight: kToolbarHeight * 1.2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: AppDimens.appBarActionRightPadding,
          ),
          child: CartBadgeWidget(onPressed: onBagPressed),
        ),
      ],
    );
  }

  /// Construye el selector de categorías
  Widget _buildCategorySelector() {
    // Si hay un callback para mostrar el selector en un modal, usamos nuestro selector personalizado
    if (onCategoryDisplay != null && rootCategories.isNotEmpty) {
      final String selectedText =
          selectedCategory?.name ?? rootCategories[0].name;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.primary.withOpacity(0.2),
          highlightColor: AppColors.textLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
          onTap: onCategoryDisplay,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.vSpace24,
              vertical: AppDimens.vSpace24 * 0.6,
            ),
            decoration: ShapeDecoration(
              color: AppColors.inputFill,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  selectedText,
                  style: AppTextStyles.inputText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppDimens.vSpace4),
                SizedBox(
                  width: AppDimens.iconSize,
                  height: AppDimens.iconSize,
                  child: SvgPicture.asset(
                    AppStrings.arrowDownIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textDark,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sino, usamos el selector original
    return CategorySelectorWidget(
      categories: rootCategories,
      selectedCategory: selectedCategory,
      onCategorySelected: onCategorySelected,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.2);
}
