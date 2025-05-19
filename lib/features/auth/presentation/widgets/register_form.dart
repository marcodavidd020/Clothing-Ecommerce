// import 'package:flutter/material.dart' show Column, Form, Widget;

// import '../../../../core/widgets/custom_text_field.dart' show CustomTextField;
// import '../helpers/auth_ui_helpers.dart';

// Widget _buildForm(bool isLoading) {
//   return Form(
//     key: _formKey,
//     child: Column(
//       children: [
//         _buildNameFields(isLoading),
//         AuthUIHelpers.smallVerticalSpace,
//         _buildEmailField(isLoading),
//         AuthUIHelpers.smallVerticalSpace,
//         _buildPhoneField(isLoading),
//         AuthUIHelpers.smallVerticalSpace,
//         _buildPasswordField(isLoading),
//         AuthUIHelpers.mediumVerticalSpace,
//         _buildSubmitButton(isLoading),
//       ],
//     ),
//   );
// }

// /// Construye los campos de nombre y apellido.
// Widget _buildNameFields(bool isLoading) {
//   return Column(
//     children: [
//       CustomTextField(
//         controller: _firstNameController,
//         hintText: AppStrings.firstnameHint,
//         validator: AuthFormValidators.validateName,
//         enabled: !isLoading,
//       ),
//       AuthUIHelpers.smallVerticalSpace,
//       CustomTextField(
//         controller: _lastNameController,
//         hintText: AppStrings.lastnameHint,
//         validator: AuthFormValidators.validateLastName,
//         enabled: !isLoading,
//       ),
//     ],
//   );
// }
