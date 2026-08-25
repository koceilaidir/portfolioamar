import 'package:flutter/material.dart';

abstract final class AppColors {

  static const Color defaultBackground = Color(0xFFF2EBDD);

  static const Color cream = Color(0xFFF2EBDD);

  static const Color creamAlt = Color(0xFFE9E0CE);

  static const Color primary = Color(0xFFE73035);

  static const Color primaryDeep = Color(0xFFBF161B);

  static const Color primaryLight = Color(0xFFEE7073);

  static const Color ink = Color(0xFF20201C);

  static const Color inkSoft = Color(0xFF5B554B);

  static const Color card = Color(0xFFFBF7EE);

  static const Color line = Color(0x2420201C);

  static const Color gridLine = Color(0x0D20201C);

  static const Color buttonShadow = Color(0x59E73035);

  static Color background = defaultBackground;

  static Color surface = card;

  static Color surfaceAlt = creamAlt;

  static Color? parseHex(String? value) {
    if (value == null) return null;
    String hex = value.trim().replaceAll('#', '').replaceAll(' ', '');
    if (hex.length == 3) {
      hex = hex.split('').map((String c) => '$c$c').join();
    }
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) return null;
    final int? parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return null;
    return Color(parsed | 0xFF000000);
  }

  static Color _shift(Color base, double amount) {
    final HSLColor hsl = HSLColor.fromColor(base);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static void applyBackground(String? hex) {
    final Color? chosen = parseHex(hex);
    if (chosen == null) {
      background = defaultBackground;
      surface = card;
      surfaceAlt = creamAlt;
      return;
    }
    background = chosen;
    final double lightness = HSLColor.fromColor(chosen).lightness;
    final double direction = lightness > 0.85 ? -1.0 : 1.0;
    surface = _shift(chosen, 0.035 * direction);
    surfaceAlt = _shift(chosen, -0.045 * direction);
  }

  static bool isTooDark(String? hex) {
    final Color? chosen = parseHex(hex);
    if (chosen == null) return false;
    return chosen.computeLuminance() < 0.45;
  }
}
