import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../../domain/entities/coupon_entity.dart';
import '../bloc/coupon_bloc.dart';
import '../../core/constants/coupon_strings.dart';
import '../../core/constants/coupon_ui.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponEntity coupon;

  const CouponCardWidget({
    super.key,
    required this.coupon,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = coupon.isExpired;
    final isUsed = coupon.isUsed;
    final isAvailable = coupon.isValidForUse;

    return Container(
      height: CouponUI.couponCardHeight,
      decoration: BoxDecoration(
        gradient: _getCardGradient(),
        borderRadius: BorderRadius.circular(CouponUI.couponCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón de fondo decorativo
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CouponUI.couponCardRadius),
              child: CustomPaint(
                painter: _CouponPatternPainter(isExpired: isExpired),
              ),
            ),
          ),
          
          // Contenido principal
          Padding(
            padding: CouponUI.couponCardPadding,
            child: Row(
              children: [
                // Información del cupón
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        coupon.name,
                        style: AppTextStyles.heading.copyWith(
                          color: _getTextColor(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.description,
                        style: AppTextStyles.body.copyWith(
                          color: _getTextColor().withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              coupon.code,
                              style: AppTextStyles.body.copyWith(
                                color: _getTextColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _copyCouponCode(context),
                            child: Icon(
                              CouponUI.copyIcon,
                              size: 16,
                              color: _getTextColor().withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Descuento y acción
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getDiscountText(),
                      style: AppTextStyles.heading.copyWith(
                        color: _getTextColor(),
                        fontSize: CouponUI.discountFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getValidityText(),
                      style: AppTextStyles.body.copyWith(
                        color: _getTextColor().withOpacity(0.8),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    if (isAvailable)
                      _buildActionButton(context)
                    else
                      _buildStatusChip(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CouponBloc>().add(ApplyCoupon(code: coupon.code));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: CouponUI.activeCouponColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: Text(
        CouponStrings.applyCoupon,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    String status;
    Color statusColor;

    if (coupon.isUsed) {
      status = CouponStrings.used;
      statusColor = CouponUI.usedCouponColor;
    } else if (coupon.isExpired) {
      status = CouponStrings.expired;
      statusColor = CouponUI.expiredCouponColor;
    } else {
      status = CouponStrings.active;
      statusColor = CouponUI.activeCouponColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  LinearGradient _getCardGradient() {
    if (coupon.isExpired || coupon.isUsed) {
      return CouponUI.expiredCouponGradient;
    }
    return CouponUI.activeCouponGradient;
  }

  Color _getTextColor() {
    return coupon.isExpired || coupon.isUsed ? AppColors.textLight : Colors.white;
  }

  String _getDiscountText() {
    if (coupon.type == CouponType.percentage) {
      return '${coupon.value.toInt()}%';
    }
    return '\$${coupon.value.toStringAsFixed(0)}';
  }

  String _getValidityText() {
    final formatter = DateTime(
      coupon.validUntil.year,
      coupon.validUntil.month,
      coupon.validUntil.day,
    );
    return '${CouponStrings.validUntil}\n${formatter.day}/${formatter.month}/${formatter.year}';
  }

  void _copyCouponCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: coupon.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(CouponStrings.copyCoupon),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _CouponPatternPainter extends CustomPainter {
  final bool isExpired;

  _CouponPatternPainter({required this.isExpired});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isExpired ? Colors.grey : Colors.white).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dibujar círculos decorativos
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width - 20 - (i * 15), 20 + (i * 10)),
        4,
        paint,
      );
    }

    // Dibujar líneas decorativas
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width - 40, 40 + (i * 8)),
        Offset(size.width - 20, 40 + (i * 8)),
        paint..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 