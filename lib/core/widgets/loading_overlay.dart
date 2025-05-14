import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Stack(
            children: [
              // Capa para bloquear la interacción con la UI detrás
              ModalBarrier(
                dismissible: false,
                color: Colors.black.withAlpha(77), // 0.3 * 255 ≈ 77
              ),
              // Indicador de carga mejorado con SpinKit
              Center(
                child: Container(
                  padding: const EdgeInsets.all(
                    AppDimens.loadingOverlayPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimens.loadingOverlayBorderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(
                          0,
                          AppDimens.loadingOverlayIndicatorSpacing,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitDoubleBounce(
                        color: AppColors.primary,
                        size: AppDimens.loadingOverlayIndicatorSize,
                      ),
                      const SizedBox(
                        height: AppDimens.loadingOverlayIndicatorSpacing,
                      ),
                      Text(AppStrings.loading, style: AppTextStyles.seeAll),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
