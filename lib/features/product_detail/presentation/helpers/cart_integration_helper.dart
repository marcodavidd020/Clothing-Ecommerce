import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper class for handling cart integration.
class CartIntegrationHelper {
  /// Gets the existing CartBloc from context or returns null if not found.
  static CartBloc? getExistingCartBloc(BuildContext context) {
    try {
      // Use mayBeOf to avoid throwing exception if not found
      return BlocProvider.of<CartBloc>(context, listen: false);
    } catch (_) {
      print(
        'CartBloc not available in upper context. Will create a local one.',
      );
      return null;
    }
  }

  /// Shows a confirmation message when a product is added to cart.
  static void showAddedToCartMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
