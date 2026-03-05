import 'package:flutter/material.dart';

/// Paleta de colores de Cynthia
/// Basada en sus colores favoritos + complementos armoniosos
class AppColors {
  AppColors._();

  // === COLORES FAVORITOS DE CYNTHIA ===
  static const Color black = Color(0xFF000000);
  static const Color midnightBlue = Color(0xFF072138);
  static const Color deepRoyal = Color(0xFF050E66);
  static const Color darkIndigo = Color(0xFF0C1148);
  static const Color cobalt = Color(0xFF00097F);

  // === COMPLEMENTOS ARMONIOSOS ===
  static const Color navyDeep = Color(0xFF1A237E);
  static const Color oceanBlue = Color(0xFF0D47A1);
  static const Color electricBlue = Color(0xFF2962FF);
  static const Color softLavender = Color(0xFFB388FF);
  static const Color paleLavender = Color(0xFFD1C4E9);
  static const Color shimmerGold = Color(0xFFFFD54F);
  static const Color warmGold = Color(0xFFFFC107);
  static const Color roseGold = Color(0xFFE8B4B8);
  static const Color starWhite = Color(0xFFE0E0FF);
  static const Color ghostWhite = Color(0xFFF0F0FF);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // === GRADIENTES PRINCIPALES ===
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [black, darkIndigo, midnightBlue],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepRoyal, cobalt, navyDeep],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softLavender, electricBlue],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [shimmerGold, warmGold],
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x33B388FF),
      Color(0x11B388FF),
      Colors.transparent,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // === SOMBRAS ===
  static List<BoxShadow> glowShadow({Color? color, double blur = 20}) {
    return [
      BoxShadow(
        color: (color ?? softLavender).withOpacity(0.3),
        blurRadius: blur,
        spreadRadius: 2,
      ),
    ];
  }

  static List<BoxShadow> subtleGlow({Color? color}) {
    return [
      BoxShadow(
        color: (color ?? softLavender).withOpacity(0.15),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ];
  }
}

