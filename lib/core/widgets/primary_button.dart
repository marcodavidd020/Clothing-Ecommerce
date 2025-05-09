import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final bool gradient;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 49,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: gradient ? null : AppColors.primary,
        gradient:
            gradient
                ? const LinearGradient(
                  colors: [Color(0xFF8A2BE2), Color(0xFFDA22FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: Size(double.infinity, double.infinity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
