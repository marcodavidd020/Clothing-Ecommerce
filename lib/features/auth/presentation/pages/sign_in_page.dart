import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/shell/presentation/presentation.dart';
import 'register_page.dart';

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
    if (!_showPasswordStep) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _showPasswordStep = true; // Muestra el campo de contraseña
        });
      }
    } else {
      if (_formKey.currentState!.validate()) {
        // TODO: Implementar lógica de inicio de sesión real (ej. API call).
        print(
          'Login con: ${_emailController.text} y ${_passwordController.text}',
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShellPage()),
        );
      }
    }
  }

  /// Navega a la página de registro [RegisterPage].
  void _onCreateAccount() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  // --- Callbacks para botones sociales (actualmente placeholders) --- ///
  void _onContinueWithApple() {
    print('Continue with Apple');
  }

  void _onContinueWithGoogle() {
    print('Continue with Google');
  }

  void _onContinueWithFacebook() {
    print('Continue with Facebook');
  }

  void _onResetPassword() {
    print('Reset password for ${_emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El CustomAppBar muestra el botón de retroceso solo si _showPasswordStep es true.
      appBar: CustomAppBar(
        showBack: _showPasswordStep,
        onBack:
            () => setState(
              () => _showPasswordStep = false,
            ), // Acción para volver al paso de email
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.vSpace16),
                Text(AppStrings.signInTitle, style: AppTextStyles.heading),
                const SizedBox(height: AppDimens.vSpace32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Muestra campo de email o contraseña según el paso actual.
                      if (!_showPasswordStep) ...[
                        CustomTextField(
                          controller: _emailController,
                          hintText: AppStrings.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return AppStrings.enterEmailError;
                            final regex = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (!regex.hasMatch(value))
                              return AppStrings.invalidEmailError;
                            return null;
                          },
                        ),
                      ] else ...[
                        CustomTextField(
                          controller: _passwordController,
                          hintText: AppStrings.passwordHint,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return AppStrings.enterPasswordError;
                            if (value.length < 6)
                              return AppStrings.invalidPasswordError;
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: AppDimens.vSpace32),
                      PrimaryButton(
                        label: AppStrings.continueLabel,
                        onPressed: _onContinue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.vSpace16),
                // Muestra "Crear cuenta" o "Resetear contraseña" según el paso.
                if (!_showPasswordStep)
                  RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: TextStyle(color: AppColors.textDark),
                      children: [
                        TextSpan(
                          text: AppStrings.createAccountLabel,
                          style: AppTextStyles.link,
                          recognizer:
                              TapGestureRecognizer()..onTap = _onCreateAccount,
                        ),
                      ],
                    ),
                  )
                else
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
                const SizedBox(height: AppDimens.vSpace32),
                // Muestra botones sociales solo en el paso de ingreso de email.
                if (!_showPasswordStep) ...[
                  SocialButton(
                    assetPath: AppStrings.appleIcon,
                    label: AppStrings.continueWithApple,
                    onPressed: _onContinueWithApple,
                  ),
                  const SizedBox(height: AppDimens.vSpace16),
                  SocialButton(
                    assetPath: AppStrings.googleIcon,
                    label: AppStrings.continueWithGoogle,
                    onPressed: _onContinueWithGoogle,
                  ),
                  const SizedBox(height: AppDimens.vSpace16),
                  SocialButton(
                    assetPath: AppStrings.facebookIcon,
                    label: AppStrings.continueWithFacebook,
                    onPressed: _onContinueWithFacebook,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
