import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/coupon_bloc.dart';
import 'coupon_card_widget.dart';
import '../../core/constants/coupon_strings.dart';

class CouponListWidget extends StatelessWidget {
  const CouponListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        if (state is CouponLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (state is CouponError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CouponBloc>().add(LoadMyCoupons());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        
        if (state is CouponLoaded) {
          final coupons = state.filteredCoupons;
          
          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    CouponStrings.noCouponsAvailable,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CouponCardWidget(coupon: coupon),
              );
            },
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
} 