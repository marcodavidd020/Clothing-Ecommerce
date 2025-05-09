import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';

/// Página para el registro de nuevos usuarios.
///
/// Contiene un formulario para ingresar nombre, apellido, email y contraseña.
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

  @override
  void dispose() {
    // Es importante liberar los controladores cuando el widget se destruye
    // para evitar fugas de memoria.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja la acción de continuar con el registro.
  /// Valida el formulario y, si es válido, procedería con la lógica de registro.
  void _onContinue() {
    // `currentState!.validate()` ejecuta los validadores de cada TextFormField.
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar la lógica de registro (ej. llamar a un BLoC/Cubit o servicio).
      print('Formulario de registro válido');
      print('Nombre: ${_firstNameController.text}');
      // Considerar navegar a otra página o mostrar un feedback al usuario.
    }
  }

  /// Maneja la acción de presionar "Reset" en el enlace de contraseña olvidada.
  /// (Actualmente placeholder, podría navegar a una pantalla de reseteo).
  void _onResetPassword() {
    // TODO: Implementar la lógica para resetear contraseña.
    print('Reset password presionado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utiliza el CustomAppBar con el botón de retroceso visible.
      appBar: const CustomAppBar(showBack: true),
      body: SafeArea( // Asegura que el contenido no se solape con áreas del sistema (notch, etc.)
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding, // Padding horizontal estándar
          ),
          child: SingleChildScrollView( // Permite scroll si el contenido excede la altura
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea hijos a la izquierda
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
                        validator: (value) => value == null || value.isEmpty
                            ? AppStrings.enterFirstnameError
                            : null,
                      ),
                      const SizedBox(height: AppDimens.vSpace16),
                      CustomTextField(
                        controller: _lastNameController,
                        hintText: AppStrings.lastnameHint,
                        validator: (value) => value == null || value.isEmpty
                            ? AppStrings.enterLastnameError
                            : null,
                      ),
                      const SizedBox(height: AppDimens.vSpace16),
                      CustomTextField(
                        controller: _emailController,
                        hintText: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) { // Validación de email más robusta
                          if (value == null || value.isEmpty) return AppStrings.enterEmailError;
                          final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                          if (!regex.hasMatch(value)) return AppStrings.invalidEmailError;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimens.vSpace16),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: AppStrings.passwordHint,
                        obscureText: true,
                        validator: (value) { // Validación de contraseña más robusta
                          if (value == null || value.isEmpty) return AppStrings.enterPasswordError;
                          if (value.length < 6) return AppStrings.invalidPasswordError;
                          return null;
                        },
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
                // Enlace para "Forgot Password? Reset"
                // Aunque esta es la página de registro, se mantiene por consistencia con el diseño original.
                // Podría ser más apropiado un enlace a "Already have an account? Sign In".
                RichText(
                  text: TextSpan(
                    text: AppStrings.forgotPasswordLabel,
                    style: TextStyle(color: AppColors.textDark), // Estilo base del texto
                    children: [
                      TextSpan(
                        text: AppStrings.resetLabel,
                        style: AppTextStyles.link, // Estilo específico para el enlace
                        recognizer: TapGestureRecognizer()..onTap = _onResetPassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.vSpace16), // Espacio adicional al final
              ],
            ),
          ),
        ),
      ),
    );
  }
}
