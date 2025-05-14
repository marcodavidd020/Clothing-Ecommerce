import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/product_item_widget.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';

class CategoryProductsPage extends StatelessWidget {
  final CategoryItemModel category;
  final List<ProductItemModel> products;

  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${category.name} (${products.length})';

    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        titleText:
            title, // Usaremos titleText para pasar el string directamente
      ),
      body: SafeArea(
        child:
            products.isEmpty
                ? Center(
                  child: Text(
                    AppStrings.noProductsFound,
                    style: AppTextStyles.inputText,
                  ),
                )
                : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal:
                        AppDimens.screenPadding, // Padding horizontal estándar
                    vertical: AppDimens.vSpace16,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppDimens.screenPadding,
                    mainAxisSpacing: AppDimens.screenPadding,
                    childAspectRatio: AppDimens.categoryProductGridAspectRatio,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductItemWidget(
                      product: product,
                      onTap: (product) {
                        // TODO: Navegar a la página de detalle del producto
                        AppLogger.logInfo('Producto seleccionado: ${product.name}');
                      },
                      onFavoriteToggle: (product) {
                        // TODO: Implementar lógica de favorito (probablemente con BLoC/Provider)
                        AppLogger.logInfo('Toggle favorito para: ${product.name}');
                      },
                    );
                  },
                ),
      ),
    );
  }
}
