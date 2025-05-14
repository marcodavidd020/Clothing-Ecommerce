import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/helpers/navigation_helper.dart';
import '../../data/models/request/request.dart' show SignInParams;
import '../bloc/bloc.dart';
import '../helpers/helpers.dart';

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

  /// Maneja la acción de resetear contraseña (actualmente placeholder)
  void _onResetPassword() {
    print('Reset password for ${_emailController.text}');
    // Implementación futura: NavigationHelper.goToResetPassword(context);
  }

  /// Maneja los eventos de botones sociales (actualmente placeholders)
  void _onContinueWithApple() {
    print('Continue with Apple');
  }

  void _onContinueWithGoogle() {
    print('Continue with Google');
  }

  void _onContinueWithFacebook() {
    print('Continue with Facebook');
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
            _buildTitle(),
            AuthUIHelpers.mediumVerticalSpace,
            _buildForm(isLoading),
            AuthUIHelpers.smallVerticalSpace,
            _buildActionLink(),
            AuthUIHelpers.mediumVerticalSpace,
            if (!_showPasswordStep && !isLoading) _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  /// Construye el título de la página
  Widget _buildTitle() {
    return AuthUIHelpers.buildAuthTitle(AppStrings.signInTitle);
  }

  /// Construye el formulario según el paso actual
  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!_showPasswordStep)
            AuthUIHelpers.buildEmailField(
              controller: _emailController,
              validator: AuthFormValidators.validateEmail,
              enabled: !isLoading,
            )
          else
            AuthUIHelpers.buildPasswordField(
              controller: _passwordController,
              validator: AuthFormValidators.validatePassword,
              enabled: !isLoading,
            ),
          AuthUIHelpers.mediumVerticalSpace,
          AuthUIHelpers.buildPrimaryButton(
            label: AppStrings.continueLabel,
            onPressed: _onContinue,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  /// Construye el enlace de acción (crear cuenta o resetear contraseña)
  Widget _buildActionLink() {
    if (!_showPasswordStep) {
      return _buildCreateAccountLink();
    } else {
      return _buildResetPasswordLink();
    }
  }

  /// Construye el enlace para crear cuenta
  Widget _buildCreateAccountLink() {
    return RichText(
      text: TextSpan(
        text: AppStrings.dontHaveAccount,
        style: TextStyle(color: AppColors.textDark),
        children: [
          TextSpan(
            text: AppStrings.createAccountLabel,
            style: AppTextStyles.link,
            recognizer: TapGestureRecognizer()..onTap = _onCreateAccount,
          ),
        ],
      ),
    );
  }

  /// Construye el enlace para resetear contraseña
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

  /// Construye los botones de inicio de sesión con redes sociales
  Widget _buildSocialButtons() {
    return Column(
      children: [
        SocialButton(
          assetPath: AppStrings.appleIcon,
          label: AppStrings.continueWithApple,
          onPressed: _onContinueWithApple,
        ),
        AuthUIHelpers.smallVerticalSpace,
        SocialButton(
          assetPath: AppStrings.googleIcon,
          label: AppStrings.continueWithGoogle,
          onPressed: _onContinueWithGoogle,
        ),
        AuthUIHelpers.smallVerticalSpace,
        SocialButton(
          assetPath: AppStrings.facebookIcon,
          label: AppStrings.continueWithFacebook,
          onPressed: _onContinueWithFacebook,
        ),
      ],
    );
  }
}
