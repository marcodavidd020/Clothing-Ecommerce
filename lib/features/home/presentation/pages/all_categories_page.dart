import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category_list_item_widget.dart';

class AllCategoriesPage extends StatelessWidget {
  final List<CategoryItemModel> categories;

  const AllCategoriesPage({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
            vertical: AppDimens.vSpace16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings
                    .shopByCategoriesTitle, // Deberás añadir esta cadena a AppStrings
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24,
                ), // Ajusta el tamaño si es necesario
              ),
              const SizedBox(
                height: AppDimens.vSpace24,
              ), // Ajusta el espacio si es necesario
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryListItemWidget(
                    category: category,
                    onTap: () {
                      // TODO: Implementar navegación a la página de productos de esta categoría
                      print('Categoría seleccionada: ${category.name}');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
