import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Importar GetIt
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';
import 'package:flutter_application_ecommerce/features/home/di_container.dart'; // Importar HomeDIContainer
import 'package:flutter_application_ecommerce/features/auth/di_container.dart'; // Importar AuthDIContainer

/// Clase para gestionar la inyección de dependencias en la aplicación
class InjectionContainer {
  /// Constructor privado para evitar instanciación
  InjectionContainer._();

  /// Instancia de GetIt
  static final GetIt sl = GetIt.instance;

  /// Inicializa el contenedor de inyección de dependencias
  static Widget init({required Widget child}) {
    // Registrar todos los módulos en GetIt
    HomeDIContainer.register(sl);
    AuthDIContainer.register(sl); // Registrar AuthDIContainer
    
    // Envolver la aplicación con los providers necesarios
    return MultiRepositoryProvider(
      providers: repositoryProviders, // Mantener si RepositoryModule se usa solo para providers
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            // Pasar la instancia de GetIt a BlocModule
            providers: BlocModule.providers(context, sl), // Modificar para pasar sl
            child: child,
          );
        },
      ),
    );
  }

  /// Obtiene todos los providers de repositorios para MultiRepositoryProvider
  static List<RepositoryProvider> get repositoryProviders => 
      RepositoryModule.providers;

  // Método para resetear el contenedor (útil para pruebas)
  static Future<void> reset() async {
    await sl.reset();
  }
} 