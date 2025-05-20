import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/network_image_with_placeholder.dart';
import 'package:flutter_application_ecommerce/core/constants/app_strings.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';

/// Widget que muestra el avatar del usuario.
///
/// Se encarga de mostrar la imagen de perfil del usuario con un diseño circular
/// y maneja las situaciones donde la imagen puede no estar disponible.
class UserAvatarWidget extends StatelessWidget {
  final UserModel? user;
  final double size;
  final VoidCallback? onTap;
  final String heroTag;

  const UserAvatarWidget({
    super.key,
    this.user,
    this.size = 90,
    this.onTap,
    this.heroTag = 'user-avatar',
  });

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = user?.avatar;
    final bool hasValidAvatar =
        avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        (avatarUrl.startsWith('http') || avatarUrl.startsWith('https'));

    return Hero(
      tag: heroTag,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 18),
        child: Center(
          child: Material(
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.3),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:
                        hasValidAvatar
                            ? NetworkImageWithPlaceholder(
                              imageUrl: avatarUrl,
                              width: size,
                              height: size,
                              fit: BoxFit.cover,
                              shape: BoxShape.circle,
                            )
                            : Image.asset(
                              AppStrings.userPlaceholderIcon,
                              width: size,
                              height: size,
                              fit: BoxFit.cover,
                            ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: AppColors.primary.withOpacity(0.1),
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
