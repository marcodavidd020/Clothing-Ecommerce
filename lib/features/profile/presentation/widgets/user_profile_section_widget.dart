import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/di/service_locator.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/user_avatar_widget.dart';
import 'package:flutter_application_ecommerce/features/profile/presentation/widgets/user_info_card_widget.dart';

/// Widget que muestra la sección completa de perfil del usuario, incluyendo
/// avatar e información personal.
class UserProfileSectionWidget extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onAvatarTap;

  const UserProfileSectionWidget({
    super.key,
    this.onEditPressed,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: ServiceLocator.sl<AuthStorage>().getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar datos',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          );
        }

        return Column(
          children: [
            UserAvatarWidget(
              user: user,
              onTap: onAvatarTap,
            ),
            UserInfoCardWidget(
              user: user,
              onEditPressed: onEditPressed,
            ),
          ],
        );
      },
    );
  }
} 