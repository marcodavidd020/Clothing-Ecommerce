import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/helpers.dart';

/// Widget que muestra la sección de botones para inicio de sesión con redes sociales.
///
/// Presenta botones para iniciar sesión con Apple, Google y Facebook.
class SocialButtonsSectionWidget extends StatelessWidget {
  final VoidCallback onApplePressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const SocialButtonsSectionWidget({
    super.key,
    required this.onApplePressed,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(
          assetPath: AppStrings.appleIcon,
          label: AppStrings.continueWithApple,
          onPressed: onApplePressed,
        ),
        AuthUIHelpers.smallVerticalSpace,
        SocialButton(
          assetPath: AppStrings.googleIcon,
          label: AppStrings.continueWithGoogle,
          onPressed: onGooglePressed,
        ),
        AuthUIHelpers.smallVerticalSpace,
        SocialButton(
          assetPath: AppStrings.facebookIcon,
          label: AppStrings.continueWithFacebook,
          onPressed: onFacebookPressed,
        ),
      ],
    );
  }
}
