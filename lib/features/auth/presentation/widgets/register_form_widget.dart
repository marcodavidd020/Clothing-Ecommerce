import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/auth/core/constants/auth_strings.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/helpers.dart';

/// Widget que muestra el formulario completo de registro.
///
/// Contiene campos para nombre, apellido, email, teléfono y contraseña.
class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildNameFields(),
          AuthUIHelpers.smallVerticalSpace,
          _buildEmailField(),
          AuthUIHelpers.smallVerticalSpace,
          _buildPhoneField(),
          AuthUIHelpers.smallVerticalSpace,
          _buildPasswordField(),
          AuthUIHelpers.mediumVerticalSpace,
          _buildSubmitButton(),
        ],
      ),
    );
  }

  /// Construye los campos de nombre y apellido.
  Widget _buildNameFields() {
    return Column(
      children: [
        CustomTextField(
          controller: firstNameController,
          hintText: AppStrings.firstnameHint,
          validator: AuthFormValidators.validateName,
          enabled: !isLoading,
        ),
        AuthUIHelpers.smallVerticalSpace,
        CustomTextField(
          controller: lastNameController,
          hintText: AppStrings.lastnameHint,
          validator: AuthFormValidators.validateLastName,
          enabled: !isLoading,
        ),
      ],
    );
  }

  /// Construye el campo de email.
  Widget _buildEmailField() {
    return AuthUIHelpers.buildEmailField(
      controller: emailController,
      validator: AuthFormValidators.validateEmail,
      enabled: !isLoading,
    );
  }

  /// Construye el campo de teléfono.
  Widget _buildPhoneField() {
    return CustomTextField(
      controller: phoneController,
      hintText: AppStrings.phoneHint,
      validator: AuthFormValidators.validatePhone,
      keyboardType: TextInputType.phone,
      enabled: !isLoading,
    );
  }

  /// Construye el campo de contraseña.
  Widget _buildPasswordField() {
    return AuthUIHelpers.buildPasswordField(
      controller: passwordController,
      validator: AuthFormValidators.validatePassword,
      enabled: !isLoading,
    );
  }

  /// Construye el botón de envío.
  Widget _buildSubmitButton() {
    return AuthUIHelpers.buildPrimaryButton(
      label: AuthStrings.continueButton,
      onPressed: onSubmit,
      isLoading: isLoading,
    );
  }
}
