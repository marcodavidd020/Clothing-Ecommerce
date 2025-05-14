import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import '../bloc/bloc.dart';
import '../helpers/helpers.dart';

/// Página para el registro de nuevos usuarios.
///
/// Contiene un formulario para ingresar nombre, apellido, email, teléfono y contraseña.
class RegisterPage extends StatefulWidget {
  /// Crea una instancia de [RegisterPage].
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Clave global para identificar y validar el formulario.
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto del formulario.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    // Es importante liberar los controladores cuando el widget se destruye
    // para evitar fugas de memoria.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Maneja la acción de continuar con el registro.
  /// Valida el formulario y, si es válido, despacha el evento de registro.
  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      AuthBlocHandler.register(
        context,
        params: RegisterParams(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        ),
      );
    }
  }

  /// Maneja la acción de resetear contraseña (actualmente placeholder).
  void _onResetPassword() {
    // Implementación futura: navegar a pantalla de reseteo
    print('Reset password presionado');
  }

  /// Maneja la acción de volver atrás.
  void _onBack() {
    NavigationHelper.goToSignIn(context);
  }

  /// Construye el título de la página.
  Widget _buildTitle() {
    return AuthUIHelpers.buildAuthTitle(AppStrings.registerTitle);
  }

  /// Construye el formulario de registro.
  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameFields(isLoading),
          AuthUIHelpers.smallVerticalSpace,
          _buildEmailField(isLoading),
          AuthUIHelpers.smallVerticalSpace,
          _buildPhoneField(isLoading),
          AuthUIHelpers.smallVerticalSpace,
          _buildPasswordField(isLoading),
          AuthUIHelpers.mediumVerticalSpace,
          _buildSubmitButton(isLoading),
        ],
      ),
    );
  }

  /// Construye los campos de nombre y apellido.
  Widget _buildNameFields(bool isLoading) {
    return Column(
      children: [
        CustomTextField(
          controller: _firstNameController,
          hintText: AppStrings.firstnameHint,
          validator: AuthFormValidators.validateName,
          enabled: !isLoading,
        ),
        AuthUIHelpers.smallVerticalSpace,
        CustomTextField(
          controller: _lastNameController,
          hintText: AppStrings.lastnameHint,
          validator: AuthFormValidators.validateLastName,
          enabled: !isLoading,
        ),
      ],
    );
  }

  /// Construye el campo de email.
  Widget _buildEmailField(bool isLoading) {
    return AuthUIHelpers.buildEmailField(
      controller: _emailController,
      validator: AuthFormValidators.validateEmail,
      enabled: !isLoading,
    );
  }

  /// Construye el campo de teléfono.
  Widget _buildPhoneField(bool isLoading) {
    return CustomTextField(
      controller: _phoneController,
      hintText: AppStrings.phoneHint,
      validator: AuthFormValidators.validatePhone,
      keyboardType: TextInputType.phone,
      enabled: !isLoading,
    );
  }

  /// Construye el campo de contraseña.
  Widget _buildPasswordField(bool isLoading) {
    return AuthUIHelpers.buildPasswordField(
      controller: _passwordController,
      validator: AuthFormValidators.validatePassword,
      enabled: !isLoading,
    );
  }

  /// Construye el botón de envío.
  Widget _buildSubmitButton(bool isLoading) {
    return AuthUIHelpers.buildPrimaryButton(
      label: AppStrings.continueLabel,
      onPressed: _onContinue,
      isLoading: isLoading,
    );
  }

  /// Construye el enlace para resetear contraseña.
  Widget _buildResetPasswordLink() {
    return RichText(
      text: TextSpan(
        text: AppStrings.forgotPasswordLabel,
        style: TextStyle(color: AppColors.textDark),
        children: [
          TextSpan(
            text: AppStrings.resetLabel,
            style: AppTextStyles.link,
            recognizer: TapGestureRecognizer()..onTap = _onResetPassword,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: AuthBlocHandler.handleAuthState,
      builder: (context, state) {
        final isLoading = AuthBlocHandler.isLoading(state);
        return Scaffold(
          appBar: CustomAppBar(showBack: true, onBack: _onBack),
          body: LoadingOverlay(
            isLoading: isLoading,
            child: SafeArea(child: _buildPageContent(isLoading)),
          ),
        );
      },
    );
  }

  /// Construye el contenido principal de la página.
  Widget _buildPageContent(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthUIHelpers.smallVerticalSpace,
            _buildTitle(),
            AuthUIHelpers.mediumVerticalSpace,
            _buildForm(isLoading),
            AuthUIHelpers.smallVerticalSpace,
            if (!isLoading) _buildResetPasswordLink(),
          ],
        ),
      ),
    );
  }
}
