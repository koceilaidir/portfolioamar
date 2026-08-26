import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/hover_region.dart';
import '../../widgets/pill_button.dart';

class NavItem {
  const NavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.scrollOffset,
    required this.onContact,
    required this.onLogoTap,
    this.navItems = const <NavItem>[],
  });

  final ValueListenable<double> scrollOffset;
  final VoidCallback onContact;
  final VoidCallback onLogoTap;
  final List<NavItem> navItems;

  static double barHeight(BuildContext context) {
    return responsive<double>(
      Breakpoints.of(context),
      mobile: 58,
      tablet: 60,
      desktop: 64,
    );
  }

  static double totalHeight(BuildContext context) =>
      barHeight(context) + MediaQuery.paddingOf(context).top;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool showNav = size != ScreenSize.mobile && navItems.isNotEmpty;
    final double topInset = MediaQuery.paddingOf(context).top;

    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (BuildContext context, double offset, Widget? child) {
        final double t = (offset / 48).clamp(0.0, 1.0);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.header,
            border: Border(
              bottom: BorderSide(
                color: AppColors.line.withValues(alpha: 0.14 * t),
              ),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(32, 32, 28, 0.06 * t),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: barHeight(context),
          child: ContentContainer(
            child: Row(
              children: <Widget>[
                Tooltip(
                  message: 'Retour en haut',
                  waitDuration: const Duration(milliseconds: 600),
                  child: HoverRegion(
                    onTap: onLogoTap,
                    builder: (BuildContext context, bool hovered) {
                      return AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        scale: hovered ? 1.08 : 1,
                        child: Image.asset(
                          'assets/logo/logo.png',
                          height: responsive<double>(size,
                              mobile: 30, tablet: 32, desktop: 36),
                          filterQuality: FilterQuality.high,
                          semanticLabel: 'Amar Hammour, retour en haut',
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                if (showNav) ...<Widget>[
                  for (final NavItem item in navItems)
                    Padding(
                      padding: const EdgeInsets.only(right: 26),
                      child: _HeaderLink(item: item),
                    ),
                ],
                PillLink(label: 'Me contacter', onTap: onContact),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.item});

  final NavItem item;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: item.onTap,
      builder: (BuildContext context, bool hovered) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              item.label.toUpperCase(),
              style: AppText.navLink.copyWith(
                color: hovered ? AppColors.headerText : AppColors.headerTextSoft,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 1.5,
              width: hovered ? 18 : 0,
              color: AppColors.primary,
            ),
          ],
        );
      },
    );
  }
}
