import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/auth/core/constants/auth_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import 'package:flutter_application_ecommerce/core/network/logger.dart';
import 'package:flutter_application_ecommerce/features/auth/data/models/request/request.dart' show SignInParams;
import 'package:flutter_application_ecommerce/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/helpers/helpers.dart';
import 'package:flutter_application_ecommerce/features/auth/presentation/widgets/widgets.dart';

/// Página de inicio de sesión para usuarios existentes.
///
/// Implementa un flujo de dos pasos: primero solicita el email y, si es válido,
/// solicita la contraseña. Permite crear una cuenta nueva o resetear la contraseña.
class SignInPage extends StatefulWidget {
  /// Crea una instancia de [SignInPage].
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Controla si se debe mostrar el paso de ingreso de contraseña.
  bool _showPasswordStep = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja la acción del botón "Continuar".
  ///
  /// Si no se muestra el paso de contraseña, valida el email y avanza al paso de contraseña.
  /// Si ya se muestra el paso de contraseña, valida la contraseña y procede al inicio de sesión.
  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    if (!_showPasswordStep) {
      setState(() => _showPasswordStep = true);
    } else {
      _submitSignInRequest();
    }
  }

  /// Envía la solicitud de inicio de sesión al BLoC
  void _submitSignInRequest() {
    AuthBlocHandler.signIn(
      context,
      params: SignInParams(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  /// Navega a la página de registro
  void _onCreateAccount() {
    NavigationHelper.goToRegister(context);
  }

  /// Maneja la acción de resetear contraseña
  void _onResetPassword() {
    AppLogger.logInfo('Reset password for ${_emailController.text}');
    // Implementación futura: NavigationHelper.goToResetPassword(context);
  }

  /// Maneja los eventos de botones sociales
  void _onContinueWithApple() {
    AppLogger.logInfo('Continue with Apple');
  }

  void _onContinueWithGoogle() {
    AppLogger.logInfo('Continue with Google');
  }

  void _onContinueWithFacebook() {
    AppLogger.logInfo('Continue with Facebook');
  }

  /// Maneja la acción de regresar al paso anterior
  void _onBackPressed() {
    setState(() => _showPasswordStep = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: AuthBlocHandler.handleAuthState,
      builder: (context, state) {
        final isLoading = AuthBlocHandler.isLoading(state);
        return Scaffold(
          appBar: _buildAppBar(),
          body: LoadingOverlay(
            isLoading: isLoading,
            child: SafeArea(child: _buildPageContent(isLoading)),
          ),
        );
      },
    );
  }

  /// Construye la barra de aplicación con botón de retroceso condicional
  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      showBack: _showPasswordStep,
      onBack: _showPasswordStep ? _onBackPressed : null,
    );
  }

  /// Construye el contenido principal de la página
  Widget _buildPageContent(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthUIHelpers.smallVerticalSpace,
            AuthUIHelpers.buildAuthTitle(AuthStrings.signInTitle),
            AuthUIHelpers.mediumVerticalSpace,
            _buildCurrentFormStep(isLoading),
            AuthUIHelpers.smallVerticalSpace,
            _buildActionLink(),
            AuthUIHelpers.mediumVerticalSpace,
            if (!_showPasswordStep && !isLoading) _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  /// Construye el paso de formulario actual basado en el estado
  Widget _buildCurrentFormStep(bool isLoading) {
    if (!_showPasswordStep) {
      return AuthStepFormWidget.emailStep(
        formKey: _formKey,
        emailController: _emailController,
        onContinue: _onContinue,
        isLoading: isLoading,
      );
    } else {
      return AuthStepFormWidget.passwordStep(
        formKey: _formKey,
        passwordController: _passwordController,
        onContinue: _onContinue,
        isLoading: isLoading,
      );
    }
  }

  /// Construye el enlace de acción apropiado según el paso actual
  Widget _buildActionLink() {
    if (!_showPasswordStep) {
      return AuthActionLinkWidget.createAccount(
        onTap: _onCreateAccount,
      );
    } else {
      return AuthActionLinkWidget.resetPassword(
        onTap: _onResetPassword,
      );
    }
  }

  /// Construye la sección de botones sociales
  Widget _buildSocialButtons() {
    return SocialButtonsSectionWidget(
      onApplePressed: _onContinueWithApple,
      onGooglePressed: _onContinueWithGoogle,
      onFacebookPressed: _onContinueWithFacebook,
    );
  }
}
