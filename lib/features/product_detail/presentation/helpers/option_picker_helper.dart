import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart'
    as core_widgets;
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';
import 'package:flutter_application_ecommerce/features/product_detail/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper class for showing option pickers for product details.
class OptionPickerHelper {
  /// Shows a size picker dialog for selecting product size.
  static void showSizePicker(BuildContext context, ProductDetailLoaded state) {
    if (state.product.availableSizes.isEmpty) return;

    final productDetailBloc = context.read<ProductDetailBloc>();

    final List<core_widgets.OptionData> sizeOptions =
        state.product.availableSizes.map((size) {
          return core_widgets.OptionData(text: size);
        }).toList();

    int selectedSizeIndex = state.product.availableSizes.indexOf(
      state.selectedSize,
    );
    if (selectedSizeIndex == -1) selectedSizeIndex = 0;

    _showOptionPicker(
      context: context,
      title: ProductDetailStrings.sizeLabel,
      options: sizeOptions,
      selectedIndex: selectedSizeIndex,
      onOptionSelected: (index) {
        productDetailBloc.add(
          ProductDetailSizeSelected(
            newSize: state.product.availableSizes[index],
          ),
        );
      },
    );
  }

  /// Shows a color picker dialog for selecting product color.
  static void showColorPicker(BuildContext context, ProductDetailLoaded state) {
    if (state.product.availableColors.isEmpty) return;

    final productDetailBloc = context.read<ProductDetailBloc>();

    final List<core_widgets.OptionData> colorOptions =
        state.product.availableColors.map((colorChoice) {
          return core_widgets.OptionData(
            text: colorChoice.name,
            colorValue: colorChoice.color,
          );
        }).toList();

    int selectedColorIndex = state.product.availableColors.indexWhere(
      (c) => c.name == state.selectedColor.name,
    );
    if (selectedColorIndex == -1) selectedColorIndex = 0;

    _showOptionPicker(
      context: context,
      title: ProductDetailStrings.colorLabel,
      options: colorOptions,
      selectedIndex: selectedColorIndex,
      onOptionSelected: (index) {
        productDetailBloc.add(
          ProductDetailColorSelected(
            newColor: state.product.availableColors[index],
          ),
        );
      },
    );
  }

  /// Shows a generic option picker dialog.
  static void _showOptionPicker({
    required BuildContext context,
    required String title,
    required List<core_widgets.OptionData> options,
    required int selectedIndex,
    required Function(int) onOptionSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext sfContext, StateSetter setStateModal) {
            return core_widgets.OptionSelectorWidget(
              title: title,
              options: options,
              selectedIndex: selectedIndex,
              onOptionSelected: (index) {
                setStateModal(() {
                  selectedIndex = index;
                });
                onOptionSelected(index);
              },
              onClose: () {
                Navigator.pop(modalContext);
              },
            );
          },
        );
      },
    );
  }
}
