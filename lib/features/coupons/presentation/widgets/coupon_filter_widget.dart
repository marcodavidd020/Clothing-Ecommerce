import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/coupon_bloc.dart';
import '../../core/constants/coupon_strings.dart';

class CouponFilterWidget extends StatelessWidget {
  const CouponFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        CouponFilterType currentFilter = CouponFilterType.all;
        
        if (state is CouponLoaded) {
          currentFilter = state.currentFilter;
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(
                context,
                label: 'Todos',
                isSelected: currentFilter == CouponFilterType.all,
                onTap: () => _filterCoupons(context, CouponFilterType.all),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: CouponStrings.availableCoupons,
                isSelected: currentFilter == CouponFilterType.available,
                onTap: () => _filterCoupons(context, CouponFilterType.available),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: CouponStrings.used,
                isSelected: currentFilter == CouponFilterType.used,
                onTap: () => _filterCoupons(context, CouponFilterType.used),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: CouponStrings.expired,
                isSelected: currentFilter == CouponFilterType.expired,
                onTap: () => _filterCoupons(context, CouponFilterType.expired),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.optionBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? AppColors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _filterCoupons(BuildContext context, CouponFilterType filterType) {
    context.read<CouponBloc>().add(FilterCoupons(filterType: filterType));
  }
} 