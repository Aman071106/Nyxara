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


  // Secondary Colors
  static const Color secondary = Color(0xFF6C63FF); // Electric purple
  static const Color secondaryLight = Color(0xFF9C93FF);
  static const Color secondaryDark = Color(0xFF4D44CC);

  // Accent Colors
  static const Color accent = Color(0xFFFF3366); // Cyber red

  // Background Colors
  static const Color backgroundSecondary = Color(0xFF111118);
  static const Color backgroundTertiary = Color(0xFF1A1A22);
  static const Color surfaceVariant = Color(0xFF2A2A3A);

  // Card and Container Colors
  static const Color cardBackgroundHover = Color(0xFF202030);
  static const Color containerBackground = Color(0xFF141420);
  static const Color containerBorder = Color(0xFF2D2D40);

  // Text Colors

  static const Color textHint = Color(0xFF606070);
  static const Color textDisabled = Color(0xFF404050);

  // Status Colors
  static const Color successDark = Color(0xFF00CC6A);
  static const Color warningDark = Color(0xFFCC8800);
  static const Color errorDark = Color(0xFFCC1235);
  static const Color infoDark = Color(0xFF0099CC);

  // Risk Level Colors
  static const Color riskCritical = Color(0xFFFF0033);
  static const Color riskHigh = Color(0xFFFF6600);
  static const Color riskMedium = Color(0xFFFFCC00);
  static const Color riskLow = Color(0xFF00FF66);
  static const Color riskSafe = Color(0xFF00DDAA);

  // Special Effects
  static const Color glow = Color(0xFF00D4AA);
  static const Color glowRed = Color(0xFFFF3366);
  static const Color glowBlue = Color(0xFF1E90FF);
  static const Color glowGreen = Color(0xFF39FF14);
  static const Color glowPurple = Color(0xFFBB86FC);

  // Cyber Grid and Lines
  static const Color gridLine = Color(0xFF2A2A3A);
  static const Color gridLineActive = Color(0xFF00D4AA);
  static const Color borderLine = Color(0xFF3A3A4A);
  static const Color borderActive = Color(0xFF00D4AA);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFF1A1A22);
  static const Color shimmerHighlight = Color(0xFF2A2A3A);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF00D4AA), // Primary
    Color(0xFF6C63FF), // Secondary
    Color(0xFFFF3366), // Accent
    Color(0xFF1E90FF), // Blue
    Color(0xFF39FF14), // Green
    Color(0xFFFF6B35), // Orange
    Color(0xFFBB86FC), // Purple
    Color(0xFFFFAA00), // Amber
  ];

  // Gradient Colors

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF111118), Color(0xFF1A1A22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF181825), Color(0xFF202030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF1E90FF), Color(0xFF6C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x4400D4AA), Colors.transparent],
    radius: 0.8,
  );



  // Cyber-themed helper methods
  static Color withCyberGlow(Color color, {double opacity = 0.3}) {
    return color.withValues(alpha:opacity);
  }

  static Color getBrightnessAdaptiveColor(Brightness brightness) {
    return brightness == Brightness.dark ? textPrimary : Color(0xFF000000);
  }

  static Color getRiskColor(String riskLevel) {
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
        return textSecondary;
    }
  }

  static List<Color> getChartColorScheme(int count) {
    return List.generate(count, (index) => chartColors[index % chartColors.length]);
  }

}

// Add these to your existing Colors class

class DashboardColors {
  // Risk Level Colors
  static const Color riskHigh = Color(0xFFE53E3E);
  static const Color riskMedium = Color(0xFFD69E2E);
  static const Color riskLow = Color(0xFF38A169);
  
  // Background Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color screenBackground = Color(0xFFF7FAFC);
  
  // Safe Status Gradient
  static const Color safeGradientStart = Color(0xFF48BB78);
  static const Color safeGradientEnd = Color(0xFF38A169);
  
  // Category Colors
  static const Color categoryBackground = Color(0xFFFED7D7);
  static const Color categoryBorder = Color(0xFFFCA5A5);
  static const Color categoryText = Color(0xFF742A2A);
  static const Color categoryChipBackground = Color(0xFFFEB2B2);
  static const Color categoryChipText = Color(0xFF9B2C2C);
  
  // Timeline Colors
  static const Color timelineBackground = Color(0xFFEBF8FF);
  static const Color timelineAccent = Color(0xFF3182CE);
  
  // Stats Colors
  static const Color statOrange = Color(0xFFD69E2E);
  static const Color statRed = Color(0xFFE53E3E);
  
  // Shadow Colors
  static const Color cardShadow = Color(0x1A000000);
  static const Color successShadow = Color(0x4D48BB78);
  
  // Text Colors
  static const Color primaryText = Color(0xFF2D3748);
  static const Color secondaryText = Color(0xFF718096);
  static const Color whiteText = Color(0xFFFFFFFF);
  
  // Icon Background Colors
  static const Color iconBackgroundRed = Color(0xFFFED7D7);
  static const Color iconBackgroundOrange = Color(0xFFFEEBC8);
  static const Color iconBackgroundGreen = Color(0xFFC6F6D5);
  static const Color iconBackgroundBlue = Color(0xFFBEE3F8);


  
}