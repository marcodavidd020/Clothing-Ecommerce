import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/widgets/option_selector_widget.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';
import 'package:go_router/go_router.dart';

/// Widget que muestra un modal para seleccionar una categoría
class CategorySelectorModal {
  /// Muestra el selector de categorías en un modal
  static void show({
    required BuildContext context,
    required List<CategoryApiModel> categories,
    required CategoryApiModel? selectedCategory,
    required Function(CategoryApiModel) onCategorySelected,
  }) {
    // Convertir categorías al formato OptionData
    final options =
        categories.map((cat) => OptionData(text: cat.name)).toList();

    // Encontrar el índice seleccionado
    int selectedIndex = 0;
    if (selectedCategory != null) {
      selectedIndex = categories.indexWhere(
        (cat) => cat.id == selectedCategory.id,
      );
      if (selectedIndex < 0) selectedIndex = 0;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => OptionSelectorWidget(
            title: 'Seleccionar Categoría',
            options: options,
            selectedIndex: selectedIndex,
            onOptionSelected: (index) {
              context.pop();
              onCategorySelected(categories[index]);
            },
            onClose: () => context.pop(),
          ),
    );
  }
}
