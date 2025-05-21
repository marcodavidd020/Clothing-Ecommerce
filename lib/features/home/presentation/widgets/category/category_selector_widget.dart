import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/entities/category_api_model.dart';

/// Widget que muestra un selector horizontal de categorías principales
class CategorySelectorWidget extends StatefulWidget {
  /// Lista de categorías principales a mostrar
  final List<CategoryApiModel> categories;

  /// Categoría seleccionada actualmente
  final CategoryApiModel? selectedCategory;

  /// Callback cuando se selecciona una categoría
  final void Function(CategoryApiModel)? onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  CategoryApiModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.selectedCategory ??
        (widget.categories.isNotEmpty ? widget.categories[0] : null);
  }

  @override
  void didUpdateWidget(CategorySelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar la categoría seleccionada si cambia en el widget padre
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      _selectedCategory = widget.selectedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            widget.categories.map((category) {
              final bool isSelected = _selectedCategory?.id == category.id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildCategoryButton(category, isSelected),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCategoryButton(CategoryApiModel category, bool isSelected) {
    return ElevatedButton(
      onPressed: () => _selectCategory(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : AppColors.textDark,
        elevation: isSelected ? 0 : 0,
        side:
            isSelected
                ? const BorderSide(color: AppColors.primary)
                : const BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
      ),
      child: Text(
        category.name,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  void _selectCategory(CategoryApiModel category) {
    if (_selectedCategory?.id != category.id) {
      setState(() {
        _selectedCategory = category;
      });

      if (widget.onCategorySelected != null) {
        widget.onCategorySelected!(category);
      }
    }
  }
}
