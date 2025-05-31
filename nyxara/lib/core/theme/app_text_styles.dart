import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmallOld = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  // Button Text
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  // Hero Text
  static const TextStyle heroTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    height: 1.1,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  // Metric Text
  static const TextStyle metricValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );

  // Add these text styles to your existing AppTextStyles class

  // Auth Screen Specific Styles
  static const TextStyle authTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle authSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle authInputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle authInputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle authInputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle authButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle authLinkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    decoration: TextDecoration.underline,
  );

  static const TextStyle authSocialButtonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle authToggleText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // Add these to your existing AppTextStyles class:


  static const TextStyle h5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  // Font families
  static const String primaryFont = 'Roboto';
  static const String monoFont = 'RobotoMono';
  static const String cyberFont = 'Orbitron'; // For cyber-themed headers

  // Display Text Styles (Largest)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: cyberFont,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: cyberFont,
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: cyberFont,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.22,
  );

  // Headline Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: cyberFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: cyberFont,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: cyberFont,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  // Title Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  // Label Text Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    height: 1.45,
  );


  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
    height: 1.33,
  );

  // Cyber-themed Specific Styles
  static const TextStyle cyberTitle = TextStyle(
    fontFamily: cyberFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.primary,
    height: 1.2,
  );

  static const TextStyle cyberSubtitle = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.primaryLight,
    height: 1.3,
  );

  static const TextStyle cyberBody = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle terminalText = TextStyle(
    fontFamily: monoFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: AppColors.accentGreen,
    height: 1.4,
  );

  static const TextStyle codeText = TextStyle(
    fontFamily: monoFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Status Text Styles
  static const TextStyle successText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    height: 1.4,
  );

  static const TextStyle warningText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.warning,
    height: 1.4,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
    height: 1.4,
  );

  static const TextStyle infoText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.info,
    height: 1.4,
  );

  // Risk Level Styles
  static const TextStyle riskCritical = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.riskCritical,
    letterSpacing: 0.8,
  );

  static const TextStyle riskHigh = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.riskHigh,
    letterSpacing: 0.8,
  );

  static const TextStyle riskMedium = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.riskMedium,
    letterSpacing: 0.8,
  );

  static const TextStyle riskLow = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.riskLow,
    letterSpacing: 0.8,
  );

  static const TextStyle riskSafe = TextStyle(
    fontFamily: cyberFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.riskSafe,
    letterSpacing: 0.8,
  );

 

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  // Animated Text Styles (for glowing effects)
  static TextStyle glowText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.primary,
    Color glowColor = AppColors.primary,
  }) {
    return TextStyle(
      fontFamily: cyberFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 1.0,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: glowColor.withValues(alpha:0.8),
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: glowColor.withValues(alpha:0.4),
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // Helper Methods
  static TextStyle getRiskTextStyle(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        return riskCritical;
      case 'high':
        return riskHigh;
      case 'medium':
        return riskMedium;
      case 'low':
        return riskLow;
      case 'safe':
        return riskSafe;
      default:
        return bodyMedium;
    }
  }

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }
}

// Add these to your existing TextStyles class

class DashboardTextStyles {
  // Card Titles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2D3748),
  );

  // Risk Level Text
  static const TextStyle riskLevelLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF718096),
  );

  static const TextStyle riskLevelValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  // Stats Text
  static const TextStyle statValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF718096),
  );

  // Category Text
  static const TextStyle categoryTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle categoryChild = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Safe Status
  static const TextStyle safeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle safeSubtitle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  // Loading Text
  static const TextStyle loadingText = TextStyle(
    fontSize: 16,
    color: Color(0xFF4A5568),
  );

  // Error Text
  static const TextStyle errorTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D3748),
  );

  static const TextStyle errorSubtitle = TextStyle(
    fontSize: 14,
    color: Color(0xFF718096),
  );
}






  