import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum LoadingIndicatorType { pulse, circle, fadingFour, cubeGrid }

class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Color barrierColor;
  final Color? indicatorColor;
  final String? loadingText;
  final double? indicatorSize;
  final LoadingIndicatorType indicatorType;
  final Color overlayColor;
  final EdgeInsetsGeometry overlayPadding;
  final double overlayBorderRadius;
  final TextStyle? textStyle;
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.barrierColor = Colors.black54,
    this.indicatorColor,
    this.loadingText,
    this.indicatorSize,
    this.indicatorType = LoadingIndicatorType.pulse,
    this.overlayColor = Colors.white,
    this.overlayPadding = const EdgeInsets.symmetric(
      vertical: 24.0,
      horizontal: 32.0,
    ),
    this.overlayBorderRadius = 16.0,
    this.textStyle,
    this.dismissible = false,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _barrierColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    _barrierColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.barrierColor,
    ).animate(_opacityAnimation);

    if (widget.isLoading) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      _toggleAnimation();
    }
  }

  void _toggleAnimation() {
    if (widget.isLoading) {
      _animationController.forward();
    } else {
      if (mounted) {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    final Color effectiveColor =
        widget.indicatorColor ?? Theme.of(context).colorScheme.primary;
    final double size =
        widget.indicatorSize ?? AppDimens.loadingOverlayIndicatorSize;

    switch (widget.indicatorType) {
      case LoadingIndicatorType.pulse:
        return SpinKitPulse(color: effectiveColor, size: size);
      case LoadingIndicatorType.circle:
        return SpinKitCircle(color: effectiveColor, size: size);
      case LoadingIndicatorType.fadingFour:
        return SpinKitFadingFour(color: effectiveColor, size: size);
      case LoadingIndicatorType.cubeGrid:
        return SpinKitCubeGrid(color: effectiveColor, size: size);
    }
  }

  Widget _buildLoadingContent() {
    final String text = widget.loadingText ?? AppStrings.loading;
    final TextStyle effectiveStyle =
        widget.textStyle ??
        TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        );

    return Semantics(
      label: text,
      // liveRegion: LiveRegionMode.assertive,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: AnimatedScale(
            scale: _opacityAnimation.value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            child: Container(
              padding: widget.overlayPadding,
              decoration: BoxDecoration(
                color: widget.overlayColor,
                borderRadius: BorderRadius.circular(widget.overlayBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLoadingIndicator(),
                  const SizedBox(height: 16.0),
                  Text(text, style: effectiveStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return IgnorePointer(
              ignoring: !widget.isLoading,
              child:
                  _opacityAnimation.value == 0
                      ? const SizedBox.shrink()
                      : Stack(
                        children: [
                          ModalBarrier(
                            dismissible: widget.dismissible,
                            color: _barrierColorAnimation.value,
                          ),
                          _buildLoadingContent(),
                        ],
                      ),
            );
          },
        ),
      ],
    );
  }
}
