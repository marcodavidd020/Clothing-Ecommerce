import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category_list_item_widget.dart';
import 'category_products_page.dart'; // Importar la página de productos de categoría

class AllCategoriesPage extends StatelessWidget {
  final List<CategoryItemModel> categories;
  // Datos de ejemplo para productos (esto debería venir de un repositorio/bloc en una app real)
  final List<ProductItemModel> _sampleProducts = List.generate(
    20,
    (index) => ProductItemModel(
      id: 'prod${index + 1}',
      name: 'Product ${index + 1}',
      imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
      price: (20 + index * 5).toDouble(),
      averageRating: (index % 5) + 0.5,
      reviewCount: 10 + index * 2,
    ),
  );

  AllCategoriesPage({super.key, required this.categories});

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
                      // Filtrar productos de ejemplo para esta categoría (lógica de demostración)
                      final categoryProducts = _sampleProducts
                          .where((p) => p.id.hashCode % categories.length == categories.indexOf(category))
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryProductsPage(
                            category: category,
                            products: categoryProducts.isNotEmpty ? categoryProducts : _sampleProducts.take(5).toList(), // Fallback si no hay productos filtrados
                          ),
                        ),
                      );
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
