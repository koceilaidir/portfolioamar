import 'package:flutter/material.dart';

/// Palette reprise à l'identique des variables CSS de la maquette.
abstract final class AppColors {
  /// --cream
  static const Color cream = Color(0xFFF2EBDD);

  /// --cream-2
  static const Color creamAlt = Color(0xFFE9E0CE);

  /// --terracotta
  static const Color terracotta = Color(0xFFC15A34);

  /// --terracotta-deep
  static const Color terracottaDeep = Color(0xFF9E4A1E);

  /// --terracotta-light
  static const Color terracottaLight = Color(0xFFE08A57);

  /// --ink
  static const Color ink = Color(0xFF20201C);

  /// --ink-soft
  static const Color inkSoft = Color(0xFF5B554B);

  /// --card
  static const Color card = Color(0xFFFBF7EE);

  /// --line : rgba(32,32,28,.14)
  static const Color line = Color(0x2420201C);

  /// Lignes de la grille du hero : rgba(32,32,28,.05)
  static const Color gridLine = Color(0x0D20201C);

  /// Ombre portée du titre "Portfolio" : rgba(158,74,30,.28)
  static const Color titleGlow = Color(0x479E4A1E);

  /// Ombre des boutons pleins : rgba(193,90,52,.35)
  static const Color buttonShadow = Color(0x59C15A34);
}
