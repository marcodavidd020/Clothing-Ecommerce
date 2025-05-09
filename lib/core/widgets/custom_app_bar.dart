import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? title;
  final VoidCallback? onBagPressed;
  final String? profileImageUrl;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    this.showBack = false,
    this.onBack,
    this.title,
    this.onBagPressed,
    this.profileImageUrl,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    if (profileImageUrl != null && onProfilePressed != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: AppDimens.screenPadding),
        child: Center(
          child: GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              radius: AppDimens.backButtonSize / 2.2,
              backgroundImage: AssetImage(profileImageUrl!),
            ),
          ),
        ),
      );
    } else if (showBack) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: AppDimens.screenPadding),
        child: GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).pop(),
          child: Container(
            width: AppDimens.backButtonSize,
            height: AppDimens.backButtonSize,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppStrings.backIcon,
                width: AppDimens.backIconSize,
                height: AppDimens.backIconSize,
              ),
            ),
          ),
        ),
      );
    } else {
      leadingWidget = SizedBox(width: AppDimens.screenPadding + AppDimens.backButtonSize);
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title,
      leading: leadingWidget,
      actions: [
        if (onBagPressed != null)
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.screenPadding),
            child: GestureDetector(
              onTap: onBagPressed,
              child: Container(
                width: AppDimens.backButtonSize,
                height: AppDimens.backButtonSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppStrings.bagIcon,
                    width: AppDimens.iconSize,
                    height: AppDimens.iconSize,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
      leadingWidth: AppDimens.screenPadding + AppDimens.backButtonSize,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
