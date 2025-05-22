import 'package:meta/meta.dart';

/// Clase base para todos los eventos del HomeBloc
@immutable
abstract class HomeEvent {}

/// Evento para cargar todos los datos de la pantalla de inicio
class LoadHomeDataEvent extends HomeEvent {}
