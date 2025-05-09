import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Lógica de registro
    }
  }

  void _onResetPassword() {
    // Lógica para resetear contraseña
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.vSpace16),
              Text(AppStrings.registerTitle, style: AppTextStyles.heading),
              const SizedBox(height: AppDimens.vSpace32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _firstNameController,
                      hintText: AppStrings.firstnameHint,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? AppStrings.enterFirstnameError
                                  : null,
                    ),
                    const SizedBox(height: AppDimens.vSpace16),
                    CustomTextField(
                      controller: _lastNameController,
                      hintText: AppStrings.lastnameHint,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? AppStrings.enterLastnameError
                                  : null,
                    ),
                    const SizedBox(height: AppDimens.vSpace16),
                    CustomTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? AppStrings.enterEmailError
                                  : null,
                    ),
                    const SizedBox(height: AppDimens.vSpace16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppStrings.passwordHint,
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? AppStrings.enterPasswordError
                                  : null,
                    ),
                    const SizedBox(height: AppDimens.vSpace32),
                    PrimaryButton(
                      label: AppStrings.continueLabel,
                      onPressed: _onContinue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.vSpace16),
              RichText(
                text: TextSpan(
                  text: AppStrings.forgotPasswordLabel,
                  style: TextStyle(color: AppColors.textDark),
                  children: [
                    TextSpan(
                      text: AppStrings.resetLabel,
                      style: AppTextStyles.link,
                      recognizer:
                          TapGestureRecognizer()..onTap = _onResetPassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
