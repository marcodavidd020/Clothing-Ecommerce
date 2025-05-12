import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/product_detail/core/core.dart';

class ImageCarouselWidget extends StatefulWidget {
  final List<String> imageList; // Imagen principal + adicionales

  const ImageCarouselWidget({super.key, required this.imageList});

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageList.isEmpty ||
        widget.imageList.every((url) => url.isEmpty)) {
      return Container(
        height: AppDimens.productDetailCarouselHeight,
        color: Colors.grey[300],
        child: const Center(child: Text(ProductDetailStrings.noImageAvailable)),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: AppDimens.productDetailCarouselHeight,
          child: PageView.builder(
            itemCount: widget.imageList.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding / 2,
                ),
                child: NetworkImageWithPlaceholder(
                  imageUrl: widget.imageList[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        if (widget.imageList.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageList.length, (index) {
              return Container(
                width: AppDimens.carouselIndicatorSize,
                height: AppDimens.carouselIndicatorSize,
                margin: const EdgeInsets.symmetric(
                  vertical: AppDimens.carouselIndicatorVerticalMargin,
                  horizontal: AppDimens.carouselIndicatorHorizontalMargin,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentImageIndex == index
                          ? AppColors.primary
                          : AppColors.inputFill,
                ),
              );
            }),
          ),
      ],
    );
  }
}
