import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/hover_region.dart';

enum PillVariant { solid, ghost, ghostOnDark }

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = PillVariant.solid,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
    this.icon,
  });

  final String label;
  final VoidCallback? onTap;
  final PillVariant variant;
  final double fontSize;
  final EdgeInsets padding;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) {
        final Color background = switch (variant) {
          PillVariant.solid =>
            hovered ? AppColors.primaryDeep : AppColors.primary,
          PillVariant.ghost =>
            hovered ? AppColors.primary : Colors.transparent,
          PillVariant.ghostOnDark =>
            hovered ? AppColors.primaryLight : Colors.transparent,
        };
        final Color foreground = switch (variant) {
          PillVariant.solid => Colors.white,
          PillVariant.ghost =>
            hovered ? Colors.white : AppColors.primaryDeep,
          PillVariant.ghostOnDark =>
            hovered ? AppColors.ink : AppColors.primaryLight,
        };
        final Border? border = switch (variant) {
          PillVariant.solid => null,
          PillVariant.ghost =>
            Border.all(color: AppColors.primary, width: 1.5),
          PillVariant.ghostOnDark =>
            Border.all(color: AppColors.primaryLight, width: 1.5),
        };

        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            border: border,
            borderRadius: BorderRadius.circular(999),
            boxShadow: variant == PillVariant.solid
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.buttonShadow,
                      blurRadius: hovered ? 24 : 18,
                      offset: Offset(0, hovered ? 12 : 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: AppText.pill.copyWith(
                  fontSize: fontSize,
                  color: foreground,
                  letterSpacing: 0,
                ),
              ),
              if (icon != null) ...<Widget>[
                const SizedBox(width: 8),
                Icon(icon, size: fontSize + 3, color: foreground),
              ],
            ],
          ),
        );
      },
    );
  }
}

class PillLink extends StatelessWidget {
  const PillLink({
    super.key,
    required this.label,
    required this.onTap,
    this.onDark = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) {
        final Color accent =
            onDark ? AppColors.primaryLight : AppColors.primary;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: hovered ? accent : Colors.transparent,
            border: Border.all(color: accent, width: 1.5),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label.toUpperCase(),
            style: AppText.pill.copyWith(
              color: hovered
                  ? (onDark ? AppColors.ink : Colors.white)
                  : (onDark ? AppColors.primaryLight : AppColors.primaryDeep),
            ),
          ),
        );
      },
    );
  }
}
