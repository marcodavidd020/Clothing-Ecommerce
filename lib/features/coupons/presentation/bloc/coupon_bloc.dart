import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/usecases/get_my_coupons_usecase.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetMyCouponsUseCase _getMyCouponsUseCase;
  final ApplyCouponUseCase _applyCouponUseCase;

  CouponBloc({
    required GetMyCouponsUseCase getMyCouponsUseCase,
    required ApplyCouponUseCase applyCouponUseCase,
  })  : _getMyCouponsUseCase = getMyCouponsUseCase,
        _applyCouponUseCase = applyCouponUseCase,
        super(CouponInitial()) {
    on<LoadMyCoupons>(_onLoadMyCoupons);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<FilterCoupons>(_onFilterCoupons);
  }

  /// Maneja el evento de cargar cupones
  Future<void> _onLoadMyCoupons(
    LoadMyCoupons event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    
    AppLogger.logInfo('🎫 Cargando cupones del usuario');
    
    final result = await _getMyCouponsUseCase.execute();
    
    result.fold(
      (failure) {
        AppLogger.logError('Error al cargar cupones: ${failure.message}');
        emit(CouponError(message: failure.message));
      },
      (coupons) {
        AppLogger.logSuccess('Cupones cargados exitosamente: ${coupons.length}');
        emit(CouponLoaded(
          coupons: coupons,
          filteredCoupons: coupons,
          currentFilter: CouponFilterType.all,
        ));
      },
    );
  }

  /// Maneja el evento de aplicar cupón
  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponLoaded) {
      emit(CouponLoading());
      
      AppLogger.logInfo('🎫 Aplicando cupón: ${event.code}');
      
      final result = await _applyCouponUseCase.execute(event.code);
      
      result.fold(
        (failure) {
          AppLogger.logError('Error al aplicar cupón: ${failure.message}');
          emit(CouponError(message: failure.message));
        },
        (appliedCoupon) {
          AppLogger.logSuccess('Cupón aplicado exitosamente: ${appliedCoupon.code}');
          emit(CouponApplied(
            appliedCoupon: appliedCoupon,
            message: 'Cupón ${appliedCoupon.code} aplicado exitosamente',
          ));
        },
      );
    }
  }

  /// Maneja el evento de remover cupón
  Future<void> _onRemoveCoupon(
    RemoveCoupon event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponLoaded) {
      final currentState = state as CouponLoaded;
      
      AppLogger.logInfo('🎫 Removiendo cupón aplicado');
      
      emit(currentState.copyWith(clearAppliedCoupon: true));
      emit(CouponRemoved(message: 'Cupón removido exitosamente'));
    }
  }

  /// Maneja el evento de filtrar cupones
  Future<void> _onFilterCoupons(
    FilterCoupons event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponLoaded) {
      final currentState = state as CouponLoaded;
      
      List<CouponEntity> filteredCoupons;
      
      switch (event.filterType) {
        case CouponFilterType.all:
          filteredCoupons = currentState.coupons;
          break;
        case CouponFilterType.available:
          filteredCoupons = currentState.availableCoupons;
          break;
        case CouponFilterType.used:
          filteredCoupons = currentState.usedCoupons;
          break;
        case CouponFilterType.expired:
          filteredCoupons = currentState.expiredCoupons;
          break;
      }
      
      AppLogger.logInfo('🎫 Filtrando cupones: ${event.filterType.name}');
      
      emit(currentState.copyWith(
        filteredCoupons: filteredCoupons,
        currentFilter: event.filterType,
      ));
    }
  }
} 