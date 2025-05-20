import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/user_model.dart';
import 'package:flutter_application_ecommerce/features/profile/core/core.dart';

/// Widget que muestra la información del usuario en forma de tarjeta.
///
/// Presenta el nombre, correo electrónico y número de teléfono del usuario
/// junto con un botón para editar el perfil.
class UserInfoCardWidget extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onEditPressed;

  const UserInfoCardWidget({
    super.key,
    required this.user,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String name = user?.fullName ?? ProfileStrings.defaultUserName;
    final String email = user?.email ?? '';
    final String phone = user?.phoneNumber ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(ProfileUI.contentPadding),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.subheading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          email,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textDark.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (phone.isNotEmpty)
                      Text(
                        phone,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textDark.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onEditPressed,
                  splashColor: AppColors.primary.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ProfileStrings.editButton,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 