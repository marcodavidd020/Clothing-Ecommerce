import 'package:flutter/material.dart';
import '../constants/constants.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.socialBackground,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          side: BorderSide.none,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 19.42),
                child: Image.asset(assetPath, width: 24, height: 24),
              ),
            ),
            Text(label, style: AppTextStyles.socialButton),
          ],
        ),
      ),
    );
  }
}
