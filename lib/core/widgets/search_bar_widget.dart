import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.homeSearchPaddingHorizontal,
          vertical: AppDimens.homeSearchPaddingVertical, // Reutilizando padding
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppStrings.searchIcon,
              width: AppDimens.iconSize,
              height: AppDimens.iconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppDimens.iconLabelGap),
            Expanded(
              child:
                  onTap != null
                      ? Text(
                        AppStrings.homeSearchHint,
                        style: AppTextStyles.inputHint,
                      ) // Muestra "Search" si es solo un botón
                      : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText:
                              AppStrings.homeSearchHint,
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
