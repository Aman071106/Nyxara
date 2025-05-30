import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8A84FF);
  static const Color primaryVariant = Color(0xFF7C3AED);

  // Background Colors
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF2D2D2D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentYellow = Color(0xFFFFB300);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // UI Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color shadowColor = Color(0x1A000000); // 10% black

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF8A84FF),
  ];

  static const Color gradientStart = Color(0xFF6366F1); // Indigo
  static const Color gradientEnd = Color(0xFF8B5CF6);   // Purple

  // Add these colors to your existing AppColors class


  // Accent Colors (add these if not already present)
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentPink = Color(0xFFEC4899);
  
  // Status Colors (add/update these)

  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);
  
  // Gradient Colors for Auth Screen
  static const Color gradientMiddle = Color(0xFF764BA2);
  
  // Auth Screen Specific Colors
  static const Color authCardBackground = Color(0xFFFBFBFB);
  static const Color authInputBackground = Color(0xFFF8FAFC);
  static const Color authInputBorder = Color(0xFFE2E8F0);
  static const Color authInputFocus = Color(0xFF4A90E2);
  static const Color authButtonGradientStart = Color(0xFF4A90E2);
  static const Color authButtonGradientEnd = Color(0xFF8B5CF6);
  static const Color authLinkColor = Color(0xFF4A90E2);
  
  // Social Login Colors
  static const Color googleColor = Color(0xFF4285F4);
  static const Color microsoftColor = Color(0xFF0078D4);
  static const Color appleColor = Color(0xFF000000);
  
  // Hover and Focus States
  static const Color hoverColor = Color(0x0A000000);
  static const Color focusColor = Color(0x1A4A90E2);
  static const Color rippleColor = Color(0x1A4A90E2);
  
  // Notification Badge
  static const Color notificationBadge = Color(0xFFEF4444);
  static const Color notificationBackground = Color(0xFFF3F4F6);
  
  // Enhanced Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1F000000);
}
