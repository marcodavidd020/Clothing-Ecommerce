import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../../addresses/domain/entities/address_entity.dart' as address_entities;

part 'order_event.dart';
part 'order_state.dart';

/// BLoC que maneja la lógica de órdenes
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final GetMyOrdersUseCase? _getMyOrdersUseCase;
  final CreateOrderUseCase? _createOrderUseCase;

  OrderBloc({
    required OrderRepository orderRepository,
    GetMyOrdersUseCase? getMyOrdersUseCase,
    CreateOrderUseCase? createOrderUseCase,
  }) : _orderRepository = orderRepository,
       _getMyOrdersUseCase = getMyOrdersUseCase,
       _createOrderUseCase = createOrderUseCase,
       super(const OrderInitial()) {
    on<LoadMyOrders>(_onLoadMyOrders);
    on<CreateOrder>(_onCreateOrder);
    on<CancelOrder>(_onCancelOrder);
    on<GetOrderDetails>(_onGetOrderDetails);
  }

  /// Maneja la carga de órdenes del usuario
  void _onLoadMyOrders(LoadMyOrders event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    
    try {
      // Usar el caso de uso si está disponible, sino usar repositorio directamente
      if (_getMyOrdersUseCase != null) {
        final result = await _getMyOrdersUseCase!.execute();
        result.fold(
          (failure) => emit(OrderError(message: failure.message)),
          (orders) => emit(OrderLoaded(orders: orders)),
        );
      } else {
        // Fallback al repositorio directo
        final result = await _orderRepository.getMyOrders();
        result.fold(
          (failure) => emit(OrderError(message: failure.message)),
          (orders) => emit(OrderLoaded(orders: orders)),
        );
      }
    } catch (e) {
      emit(OrderError(message: 'Error inesperado: $e'));
    }
  }

  /// Maneja la creación de una nueva orden
  void _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    
    try {
      // Usar el caso de uso si está disponible, sino usar repositorio directamente
      if (_createOrderUseCase != null) {
        final result = await _createOrderUseCase!.execute(
          items: event.items,
          shippingAddress: event.shippingAddress,
          billingAddress: event.billingAddress,
          couponCode: event.couponCode,
        );
        result.fold(
          (failure) => emit(OrderError(message: failure.message)),
          (order) => emit(OrderCreated(
            order: order,
            message: 'Orden creada exitosamente',
          )),
        );
      } else {
        // Fallback al repositorio directo
        final result = await _orderRepository.createOrder(
          items: event.items,
          shippingAddress: event.shippingAddress,
          billingAddress: event.billingAddress,
          couponCode: event.couponCode,
        );
        result.fold(
          (failure) => emit(OrderError(message: failure.message)),
          (order) => emit(OrderCreated(
            order: order,
            message: 'Orden creada exitosamente',
          )),
        );
      }
    } catch (e) {
      emit(OrderError(message: 'Error inesperado: $e'));
    }
  }

  /// Maneja la cancelación de una orden
  void _onCancelOrder(CancelOrder event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    
    try {
      final result = await _orderRepository.cancelOrder(event.orderId);
      
      result.fold(
        (failure) => emit(OrderError(message: failure.message)),
        (order) => emit(const OrderCancelled(message: 'Orden cancelada exitosamente')),
      );
    } catch (e) {
      emit(OrderError(message: 'Error inesperado: $e'));
    }
  }

  /// Maneja la obtención de detalles de una orden
  void _onGetOrderDetails(GetOrderDetails event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    
    try {
      final result = await _orderRepository.getOrder(event.orderId);
      
      result.fold(
        (failure) => emit(OrderError(message: failure.message)),
        (order) => emit(OrderLoaded(orders: [order])),
      );
    } catch (e) {
      emit(OrderError(message: 'Error inesperado: $e'));
    }
  }
} 