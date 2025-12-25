import 'package:flutter/material.dart';

/// App-wide color constants following the design specifications
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryRed = Color(0xFFB71C1C);
  static const Color primaryLightPink = Color(0xFFFFEBEE);

  // Background Colors
  static const Color scaffoldBg = Color(0xFFF5F5F5);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Stat Card Icon Colors
  static const Color salesGreen = Color(0xFF4CAF50);
  static const Color cashYellow = Color(0xFFFFC107);
  static const Color netSalesOrange = Color(0xFFFF9800);
  static const Color expenseBlue = Color(0xFF2196F3);
  static const Color taxGrey = Color(0xFF607D8B);
  static const Color discountRed = Color(0xFFE91E63);

  // Gradient Colors (Total Sales Card)
  static const Color gradientStart = Color(0xFFFCE4EC);
  static const Color gradientEnd = Color(0xFFFFFFFF);

  // Gradient for Total Sales Card
  static const LinearGradient totalSalesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}
