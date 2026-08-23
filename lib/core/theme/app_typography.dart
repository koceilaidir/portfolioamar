import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Familles de polices embarquées (assets/fonts).
abstract final class AppFonts {
  /// Fraunces optique "display" — pour les grands titres.
  static const String display = 'FrauncesDisplay';

  /// Fraunces optique "texte" — pour les titres secondaires et citations.
  static const String serif = 'Fraunces';

  /// Manrope — texte courant, boutons, labels.
  static const String sans = 'Manrope';

  /// Caveat — signature manuscrite.
  static const String script = 'Caveat';
}

/// Styles de texte repris des règles CSS de la maquette.
abstract final class AppText {
  // --- Barre du haut -------------------------------------------------------
  static const TextStyle role = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 2,
    color: AppColors.ink,
  );

  static const TextStyle navLink = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11.5,
    height: 1.2,
    letterSpacing: 1.4,
    color: AppColors.inkSoft,
  );

  static const TextStyle pill = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 1,
  );

  // --- Hero ----------------------------------------------------------------
  static TextStyle heroTitle(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        height: 1,
        letterSpacing: -1,
        color: AppColors.terracotta,
      );

  static const TextStyle hello = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.2,
    letterSpacing: 2,
    color: AppColors.inkSoft,
  );

  static TextStyle name(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        height: 0.98,
        color: AppColors.ink,
      );

  static const TextStyle subrole = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.3,
    letterSpacing: 2,
    color: AppColors.terracottaDeep,
  );

  static const TextStyle lede = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.55,
    color: AppColors.inkSoft,
  );

  static TextStyle signature(double fontSize) => TextStyle(
        fontFamily: AppFonts.script,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        height: 1.1,
        color: AppColors.ink,
      );

  // --- Titres de section ---------------------------------------------------
  static TextStyle sectionKicker(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.05,
        color: AppColors.ink,
      );

  static const TextStyle sectionDesc = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.6,
    color: AppColors.inkSoft,
  );

  static const TextStyle linkAll = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 1,
    color: AppColors.terracottaDeep,
  );

  // --- Projets -------------------------------------------------------------
  static TextStyle projectThumb(double fontSize) => TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.05,
        color: Colors.white,
      );

  static const TextStyle projectNumber = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.1,
    color: AppColors.terracotta,
  );

  static const TextStyle projectTitle = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.2,
    color: AppColors.ink,
  );

  static const TextStyle projectSubtitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.45,
    color: AppColors.inkSoft,
  );

  // --- Compétences ---------------------------------------------------------
  static const TextStyle skillLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.ink,
  );

  static const TextStyle skillValue = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.3,
    color: AppColors.inkSoft,
  );

  static TextStyle quote(double fontSize) => TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        height: 1.35,
        color: AppColors.ink,
      );

  static const TextStyle featureTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.ink,
  );

  static const TextStyle featureBody = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    color: AppColors.inkSoft,
  );

  // --- Témoignages ---------------------------------------------------------
  static const TextStyle testimonial = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.6,
    color: AppColors.inkSoft,
  );

  static const TextStyle testimonialName = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.35,
    color: AppColors.ink,
  );

  static const TextStyle testimonialRole = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.35,
    color: AppColors.inkSoft,
  );

  // --- Pied de page --------------------------------------------------------
  static TextStyle footerTitle(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.05,
        color: AppColors.cream,
      );

  static const TextStyle footerBody = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.6,
    color: AppColors.cream,
  );

  static const TextStyle footerRow = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
    color: AppColors.cream,
  );

  static const TextStyle footerLegal = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.5,
    color: AppColors.cream,
  );
}
