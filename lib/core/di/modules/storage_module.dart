import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/storage/storage_service.dart';
import 'package:flutter_application_ecommerce/core/storage/shared_preferences_service.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';

/// Módulo para la inyección de servicios de almacenamiento
class StorageModule {
  /// Registra los servicios de almacenamiento en GetIt
  static Future<void> register(GetIt sl) async {
    // Registrar servicio de almacenamiento
    if (!sl.isRegistered<StorageService>()) {
      final sharedPrefsService = SharedPreferencesService();
      await sharedPrefsService.init(); // Inicializar SharedPreferences
      sl.registerLazySingleton<StorageService>(() => sharedPrefsService);
    }

    // Registrar servicio de autenticación
    if (!sl.isRegistered<AuthStorage>()) {
      sl.registerLazySingleton<AuthStorage>(
        () => AuthStorage(sl<StorageService>()),
      );
    }
  }
} 