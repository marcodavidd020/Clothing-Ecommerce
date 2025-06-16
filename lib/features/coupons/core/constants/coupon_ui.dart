import 'package:flutter/material.dart';

/// Constantes de UI para la funcionalidad de cupones
class CouponUI {
  // Dimensiones
  static const double couponCardHeight = 120.0;
  static const double couponCardRadius = 12.0;
  static const double couponIconSize = 24.0;
  static const double discountFontSize = 24.0;
  
  // Padding y margins
  static const EdgeInsets couponCardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets couponListPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  
  // Colores
  static const Color activeCouponColor = Color(0xFF4CAF50);
  static const Color usedCouponColor = Color(0xFF9E9E9E);
  static const Color expiredCouponColor = Color(0xFFF44336);
  static const Color discountTextColor = Color(0xFF2E7D32);
  
  // Gradientes
  static const LinearGradient activeCouponGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient expiredCouponGradient = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Iconos
  static const IconData couponIcon = Icons.local_offer;
  static const IconData activeIcon = Icons.check_circle;
  static const IconData usedIcon = Icons.history;
  static const IconData expiredIcon = Icons.cancel;
  static const IconData copyIcon = Icons.copy;
  static const IconData detailsIcon = Icons.info_outline;
  
  // Duraciones de animación
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);
  static const Duration slideAnimationDuration = Duration(milliseconds: 250);
} 