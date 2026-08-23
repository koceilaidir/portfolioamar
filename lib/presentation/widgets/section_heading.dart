import 'package:flutter/material.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/hover_region.dart';
import '../../data/models/portfolio_content.dart';

/// Titre de section : `.sec-kicker` + `.sec-desc` + `.link-all`.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.copy,
    this.onLinkTap,
    this.alignment = CrossAxisAlignment.start,
  });

  final SectionCopy copy;
  final VoidCallback? onLinkTap;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final double titleSize =
        responsive<double>(size, mobile: 26, tablet: 34, desktop: 42);

    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(
          copy.title,
          style: AppText.sectionKicker(titleSize),
        ),
        Text(
          copy.accent,
          style: AppText.sectionKicker(titleSize)
              .copyWith(color: AppColors.terracotta),
        ),
        if (copy.description != null) ...<Widget>[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: responsive<double>(size, mobile: 280, tablet: 420, desktop: 460),
            ),
            child: Text(
              copy.description!,
              style: AppText.sectionDesc.copyWith(
                fontSize: responsive<double>(size, mobile: 13, tablet: 14, desktop: 15),
              ),
            ),
          ),
        ],
        if (copy.linkLabel != null) ...<Widget>[
          const SizedBox(height: 12),
          _SectionLink(label: copy.linkLabel!, onTap: onLinkTap),
        ],
      ],
    );
  }
}

class _SectionLink extends StatelessWidget {
  const _SectionLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label.toUpperCase(),
              style: AppText.linkAll.copyWith(
                color: hovered ? AppColors.terracotta : AppColors.terracottaDeep,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              offset: Offset(hovered ? 0.35 : 0, 0),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: hovered ? AppColors.terracotta : AppColors.terracottaDeep,
              ),
            ),
          ],
        );
      },
    );
  }
}
