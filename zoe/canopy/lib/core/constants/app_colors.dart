import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6366F1); // Indigo-500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo-600
  static const Color accent = Color(0xFF06B6D4); // Cyan-500

  // Background colors for glass effect
  static const Color backgroundStart = Color(0xFF0F0F23); // Dark purple-blue
  static const Color backgroundEnd = Color(0xFF000000); // Pure black
  static const Color backgroundSecondary = Color(0xFF1A1A2E); // Dark blue-grey

  // Glass effect colors
  static const Color glassFill = Color(0x1AFFFFFF); // 10% white opacity
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white opacity
  static const Color glassHover = Color(0x26FFFFFF); // 15% white opacity

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white opacity
  static const Color textTertiary = Color(0x66FFFFFF); // 40% white opacity
  static const Color textMuted = Color(0x4DFFFFFF); // 30% white opacity

  // Input field colors
  static const Color inputFill = Color(0x1A000000); // 10% black opacity
  static const Color inputBorder = Color(0x33FFFFFF); // 20% white opacity
  static const Color inputFocused = Color(0xFF6366F1); // Primary color

  // State colors
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // Loading and disabled states
  static const Color loading = Color(0x4D6366F1); // 30% primary opacity
  static const Color disabled = Color(0x4DFFFFFF); // 30% white opacity

  // Card and surface colors
  static const Color cardBackground = Color(0x0DFFFFFF); // 5% white opacity
  static const Color surfaceElevated = Color(0x1AFFFFFF); // 10% white opacity

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowDark = Color(0x33000000); // 20% black
  static const Color shadowColored = Color(0x336366F1); // 20% primary

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassFill, Color(0x0DFFFFFF)],
  );
}
