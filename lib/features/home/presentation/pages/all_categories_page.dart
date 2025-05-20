import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/helpers.dart';

/// Página que muestra todas las categorías disponibles
class AllCategoriesPage extends StatelessWidget {
  /// Constructor
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true),
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: HomeBlocHandler.handleHomeState,
          builder: (context, state) {
            if (HomeBlocHandler.isLoading(state)) {
              return HomeUIHelpers.loadingPlaceholder;
            }

            if (state is HomeError) {
              return ErrorContentWidget(
                message: state.message,
                onRetry: () => HomeBlocHandler.loadHomeData(context),
              );
            }

            if (state is HomeLoaded) {
              return _buildCategoriesContent(context, state.categories);
            }

            // Estado por defecto o no manejado
            return ErrorContentWidget(
              message: 'Estado no manejado. Por favor, intente nuevamente.',
              onRetry: () => HomeBlocHandler.loadHomeData(context),
            );
          },
        ),
      ),
    );
  }

  /// Construye el contenido principal con la lista de categorías
  Widget _buildCategoriesContent(BuildContext context, List<CategoryItemModel> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noCategoriesFound,
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
            style: AppTextStyles.heading.copyWith(fontSize: 24),
          ),
          HomeUIHelpers.mediumVerticalSpace,
          _buildCategoriesList(context, categories),
        ],
      ),
    );
  }

  /// Construye la lista de categorías
  Widget _buildCategoriesList(BuildContext context, List<CategoryItemModel> categories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListItemWidget(
          category: category,
          onTap: () => HomeNavigationHelper.goToCategoryProducts(context, category),
        );
      },
    );
  }
}
