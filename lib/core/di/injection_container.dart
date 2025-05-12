import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';

/// Clase para gestionar la inyección de dependencias en la aplicación
class InjectionContainer {
  /// Constructor privado para evitar instanciación
  InjectionContainer._();
  
  /// Obtiene todos los providers de repositorios para MultiRepositoryProvider
  static List<RepositoryProvider> get repositoryProviders => 
      RepositoryModule.providers;
  
  /// Envuelve la aplicación con todos los providers necesarios
  static Widget init({required Widget child}) {
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: BlocModule.providers(context),
            child: child,
          );
        },
      ),
    );
  }
} 