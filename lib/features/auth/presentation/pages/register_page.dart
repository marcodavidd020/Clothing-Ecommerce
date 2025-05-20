import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/auth/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/widgets/widgets.dart';

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
          phone:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
        ),
      );
    }
  }

  /// Maneja la acción de resetear contraseña.
  void _onResetPassword() {
    // Implementación futura: navegar a pantalla de reseteo
    AppLogger.logInfo('Reset password presionado');
  }

  /// Maneja la acción de volver atrás.
  void _onBack() {
    NavigationHelper.goToSignIn(context);
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
            AuthUIHelpers.buildAuthTitle(AppStrings.registerTitle),
            AuthUIHelpers.mediumVerticalSpace,
            RegisterFormWidget(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              passwordController: _passwordController,
              onSubmit: _onContinue,
              isLoading: isLoading,
            ),
            AuthUIHelpers.smallVerticalSpace,
            if (!isLoading)
              AuthActionLinkWidget.resetPassword(onTap: _onResetPassword),
          ],
        ),
      ),
    );
  }
}
