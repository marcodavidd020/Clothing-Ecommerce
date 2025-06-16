import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/coupon_bloc.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../core/constants/coupon_strings.dart';

/// Widget para aplicar cupones en el checkout
class CheckoutCouponWidget extends StatefulWidget {
  final double orderAmount;
  final Function(CouponEntity? coupon) onCouponChanged;
  final CouponEntity? appliedCoupon;

  const CheckoutCouponWidget({
    super.key,
    required this.orderAmount,
    required this.onCouponChanged,
    this.appliedCoupon,
  });

  @override
  State<CheckoutCouponWidget> createState() => _CheckoutCouponWidgetState();
}

class _CheckoutCouponWidgetState extends State<CheckoutCouponWidget> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CouponBloc, CouponState>(
      listener: (context, state) {
        if (state is CouponApplied) {
          widget.onCouponChanged(state.appliedCoupon);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
        } else if (state is CouponError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.optionBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cupones de descuento',
              style: AppTextStyles.heading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            if (widget.appliedCoupon != null)
              _buildAppliedCouponCard()
            else
              _buildCouponInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedCouponCard() {
    final coupon = widget.appliedCoupon!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Código: ${coupon.code}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => widget.onCouponChanged(null),
            child: Text('Remover', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: CouponStrings.couponCodeHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => _applyCoupon(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _applyCoupon,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }

  void _applyCoupon() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      context.read<CouponBloc>().add(ApplyCoupon(code: code));
      _codeController.clear();
    }
  }
} 