import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';

/// Módulo para la inyección de BLoCs
class BlocModule {
  /// Registra todos los BLoCs como providers
  static List<BlocProvider> providers(BuildContext context) {
    // Obtenemos los repositorios del context
    final HomeRepository homeRepository = context.read<HomeRepository>();
    
    return [
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(
          getCategoriesUseCase: GetCategoriesUseCase(homeRepository),
          getTopSellingProductsUseCase: GetTopSellingProductsUseCase(homeRepository),
          getNewInProductsUseCase: GetNewInProductsUseCase(homeRepository),
          getProductsByCategoryUseCase: GetProductsByCategoryUseCase(homeRepository),
        ),
      ),
      // Aquí se pueden agregar más BLoCs a medida que la aplicación crezca
    ];
  }
} 