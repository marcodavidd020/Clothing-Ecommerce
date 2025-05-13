import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importar flutter_bloc
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart'; // Importar NavigationHelper
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
// import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart'; // Importar el HomeBloc
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/category_list_item_widget.dart';
// import 'category_products_page.dart'; // Ya no se importa directamente aquí

class AllCategoriesPage extends StatelessWidget {
  // Eliminar el parámetro categories
  // final List<CategoryItemModel> categories;

  // Eliminar datos de ejemplo
  // final List<ProductItemModel> _sampleProducts = List.generate(
  //   20,
  //   (index) => ProductItemModel(
  //     id: 'prod${index + 1}',
  //     name: 'Product ${index + 1}',
  //     imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/008/530/101/small_2x/sport-t-shirt-cutout-file-png.png',
  //     price: (20 + index * 5).toDouble(),
  //     averageRating: (index % 5) + 0.5,
  //     reviewCount: 10 + index * 2,
  //   ),
  // );

  const AllCategoriesPage({super.key}); // Modificar constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true),
      body: SafeArea(
        // Envolver con BlocBuilder
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            // Manejar estados de carga y error
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text(state.message)); // Mostrar mensaje de error
            }

            if (state is HomeLoaded) {
              // Usar las categorías del estado
              final loadedCategories = state.categories;

              if (loadedCategories.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noCategoriesFound, // Asumir que existe o añadir
                    style: AppTextStyles.inputText,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding,
                  vertical: AppDimens.vSpace16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.shopByCategoriesTitle,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: AppDimens.vSpace24,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loadedCategories.length,
                      itemBuilder: (context, index) {
                        final category = loadedCategories[index];
                        return CategoryListItemWidget(
                          category: category,
                          onTap: () {
                            // Usar NavigationHelper para navegar
                            NavigationHelper.goToCategoryProducts(context, category.name); // Usar category.name en lugar de category.id
                            print('Categoría seleccionada para navegar: ${category.name}'); // Corregido category.id a category.name
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            // Estado por defecto o no manejado
            return const Center(child: Text('Estado no manejado en AllCategoriesPage'));
          },
        ),
      ),
    );
  }
}
