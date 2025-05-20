import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/helpers.dart';

/// Widget que muestra un paso del formulario de autenticación.
///
/// Permite mostrar campos de formulario con un botón de acción principal.
class AuthStepFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final bool isLoading;

  const AuthStepFormWidget({
    super.key,
    required this.formKey,
    required this.fields,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.isLoading = false,
  });

  /// Construye un formulario para el paso de ingreso de email
  factory AuthStepFormWidget.emailStep({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required VoidCallback onContinue,
    required bool isLoading,
  }) {
    return AuthStepFormWidget(
      formKey: formKey,
      fields: [
        AuthUIHelpers.buildEmailField(
          controller: emailController,
          validator: AuthFormValidators.validateEmail,
          enabled: !isLoading,
        ),
      ],
      buttonLabel: AppStrings.continueLabel,
      onButtonPressed: onContinue,
      isLoading: isLoading,
    );
  }

  /// Construye un formulario para el paso de ingreso de contraseña
  factory AuthStepFormWidget.passwordStep({
    required GlobalKey<FormState> formKey,
    required TextEditingController passwordController,
    required VoidCallback onContinue,
    required bool isLoading,
  }) {
    return AuthStepFormWidget(
      formKey: formKey,
      fields: [
        AuthUIHelpers.buildPasswordField(
          controller: passwordController,
          validator: AuthFormValidators.validatePassword,
          enabled: !isLoading,
        ),
      ],
      buttonLabel: AppStrings.continueLabel,
      onButtonPressed: onContinue,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ...fields,
          AuthUIHelpers.mediumVerticalSpace,
          AuthUIHelpers.buildPrimaryButton(
            label: buttonLabel,
            onPressed: onButtonPressed,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
