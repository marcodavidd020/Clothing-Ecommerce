import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/coupon_bloc.dart';
import '../../core/constants/coupon_strings.dart';
import '../../core/constants/coupon_ui.dart';

class CouponApplyWidget extends StatefulWidget {
  const CouponApplyWidget({super.key});

  @override
  State<CouponApplyWidget> createState() => _CouponApplyWidgetState();
}

class _CouponApplyWidgetState extends State<CouponApplyWidget> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      context.read<CouponBloc>().add(ApplyCoupon(code: code));
      _codeController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimens.screenPadding),
      padding: CouponUI.couponCardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(CouponUI.couponCardRadius),
        border: Border.all(color: AppColors.optionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CouponStrings.applyCoupon,
            style: AppTextStyles.heading.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: CouponStrings.couponCodeHint,
                                         hintStyle: AppTextStyles.body.copyWith(
                       color: AppColors.textLight,
                     ),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.optionBorder),
                     ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _applyCoupon(),
                ),
              ),
              const SizedBox(width: 12),
              BlocBuilder<CouponBloc, CouponState>(
                builder: (context, state) {
                  final isLoading = state is CouponLoading;
                  
                  return ElevatedButton(
                    onPressed: isLoading ? null : _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(AppColors.white),
                            ),
                          )
                        : Text(CouponStrings.applyCoupon),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 