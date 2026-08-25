import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppFonts {

  static const String display = 'Poppins';

  static const String serif = 'Poppins';

  static const String sans = 'Manrope';

  static const String script = 'Caveat';
}

abstract final class AppText {

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

  static TextStyle heroSentence(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.1,
        letterSpacing: -fontSize * 0.022,
        color: AppColors.ink,
      );

  static const TextStyle kicker = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 10.5,
    height: 1.2,
    letterSpacing: 2,
    color: AppColors.inkSoft,
  );

  static const TextStyle subrole = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.3,
    letterSpacing: 2,
    color: AppColors.primaryDeep,
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

  static TextStyle sectionKicker(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.14,
        letterSpacing: -fontSize * 0.015,
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
    color: AppColors.primaryDeep,
  );

  static TextStyle projectThumb(double fontSize) => TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.12,
        letterSpacing: -fontSize * 0.01,
        color: Colors.white,
      );

  static const TextStyle projectNumber = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.1,
    color: AppColors.primary,
  );

  static const TextStyle projectTitle = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.3,
    color: AppColors.ink,
  );

  static const TextStyle projectSubtitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.45,
    color: AppColors.inkSoft,
  );

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
        height: 1.45,
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

  static TextStyle footerTitle(double fontSize) => TextStyle(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1.14,
        letterSpacing: -fontSize * 0.015,
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
