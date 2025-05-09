import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/shell/presentation/presentation.dart';
import 'register_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPasswordStep = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_showPasswordStep) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _showPasswordStep = true;
        });
      }
    } else {
      if (_formKey.currentState!.validate()) {
        // Lógica de inicio de sesión con email y password
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShellPage()),
        );
      }
    }
  }

  void _onCreateAccount() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  void _onContinueWithApple() {}
  void _onContinueWithGoogle() {}
  void _onContinueWithFacebook() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: _showPasswordStep,
        onBack: () => setState(() => _showPasswordStep = false),
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
                      if (!_showPasswordStep) ...[
                        CustomTextField(
                          controller: _emailController,
                          hintText: AppStrings.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.enterEmailError;
                            }
                            final regex = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (!regex.hasMatch(value)) {
                              return AppStrings.invalidEmailError;
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        CustomTextField(
                          controller: _passwordController,
                          hintText: AppStrings.passwordHint,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.enterPasswordError;
                            }
                            if (value.length < 6) {
                              return AppStrings.invalidPasswordError;
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: AppDimens.vSpace32),
                      PrimaryButton(
                        label: AppStrings.continueLabel,
                        onPressed: _onContinue,
                        // gradient: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.vSpace16),
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
                          style: TextStyle(color: AppColors.link),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  /*Reset logic*/
                                },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppDimens.vSpace32),
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
