import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/di_container.dart';
import 'package:flutter_application_ecommerce/features/cart/di_container.dart';

/// Módulo para la inyección de BLoCs
class BlocModule {
  /// Registra todos los BLoCs como providers
  static List<BlocProvider> providers(BuildContext context, GetIt sl) {
    // Obtenemos los repositorios del context
    // final HomeRepository homeRepository = context.read<HomeRepository>();

    return [
      // Obtener HomeBloc usando GetIt
      BlocProvider<HomeBloc>(create: (context) => sl<HomeBloc>()),

      // Agregar providers del módulo Auth
      ...AuthDIContainer.getBlocProviders(sl),

      // Agregar providers del módulo Cart
      ...CartDIContainer.getBlocProviders(sl),

      // Aquí se pueden agregar más BLoCs a medida que la aplicación crezca
    ];
  }
}
