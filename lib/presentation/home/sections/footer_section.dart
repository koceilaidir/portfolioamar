import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/widgets/hover_region.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/pill_button.dart';

/// Pied de page / section contact — `.foot`.
class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
    required this.contact,
    required this.ownerName,
  });

  final ContactInfo contact;
  final String ownerName;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool wide = size == ScreenSize.desktop;
    final double titleSize =
        responsive<double>(size, mobile: 30, tablet: 40, desktop: 52);

    final Widget headline = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(contact.headline, style: AppText.footerTitle(titleSize)),
        Text(
          contact.headlineAccent,
          style: AppText.footerTitle(titleSize)
              .copyWith(color: AppColors.terracottaLight),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Opacity(
            opacity: 0.8,
            child: Text(contact.pitch, style: AppText.footerBody),
          ),
        ),
      ],
    );

    final Widget details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ContactRow(
          iconKey: 'mail',
          label: contact.email,
          onTap: () => AppLauncher.email(context, contact.email),
        ),
        _ContactRow(
          iconKey: 'link',
          label: contact.website,
          onTap: () => AppLauncher.website(context, contact.website),
        ),
        _ContactRow(
          iconKey: 'available',
          label: contact.availability,
          bottomSpacing: 0,
        ),
        const SizedBox(height: 22),
        PillButton(
          label: 'Me contacter',
          onTap: () => AppLauncher.email(context, contact.email),
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 60, desktop: 90),
      ),
      padding: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 48, desktop: 70),
        bottom: responsive<double>(size, mobile: 40, tablet: 52, desktop: 74),
      ),
      decoration: const BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Reveal(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(flex: 6, child: headline),
                        const SizedBox(width: 48),
                        Expanded(flex: 5, child: details),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        headline,
                        const SizedBox(height: 16),
                        details,
                      ],
                    ),
            ),
            SizedBox(height: responsive<double>(size, mobile: 30, tablet: 40, desktop: 56)),
            Divider(color: AppColors.cream.withValues(alpha: 0.14), height: 1),
            const SizedBox(height: 18),
            Opacity(
              opacity: 0.6,
              child: Text(
                '© 2026 $ownerName — Tous droits réservés.',
                style: AppText.footerLegal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.iconKey,
    required this.label,
    this.onTap,
    this.bottomSpacing = 16,
  });

  final String iconKey;
  final String label;
  final VoidCallback? onTap;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: HoverRegion(
        onTap: onTap,
        builder: (BuildContext context, bool hovered) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hovered && onTap != null
                      ? AppColors.terracotta
                      : Colors.transparent,
                  border: Border.all(
                    color: hovered && onTap != null
                        ? AppColors.terracotta
                        : AppColors.cream.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  AppIcons.resolve(iconKey),
                  size: 15,
                  color: hovered && onTap != null
                      ? Colors.white
                      : AppColors.terracottaLight,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: AppText.footerRow.copyWith(
                    decoration: hovered && onTap != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: AppColors.terracottaLight,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
