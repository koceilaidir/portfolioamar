import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/grid_fade.dart';
import '../../widgets/hero_sentence.dart';
import '../../widgets/pill_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.profile,
    required this.topPadding,
    required this.onProjects,
    required this.onContact,
  });

  final ProfileInfo profile;
  final double topPadding;
  final VoidCallback onProjects;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final double wordmarkWidth =
        responsive<double>(size, mobile: 344, tablet: 600, desktop: 790);
    final double ledeSize =
        responsive<double>(size, mobile: 14.5, tablet: 17, desktop: 19);
    final double ledeWidth =
        responsive<double>(size, mobile: 520, tablet: 580, desktop: 660);
    final bool hasSentence = profile.heroSentence.trim().isNotEmpty;
    final bool fillScreen = size == ScreenSize.mobile;
    final double bottomPadding =
        responsive<double>(size, mobile: 34, tablet: 54, desktop: 74);

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GridFade(
              cell: responsive<double>(size, mobile: 26, tablet: 30, desktop: 34),
              center: const Alignment(0, -0.1),
            ),
          ),
          _FillScreen(
            enabled: fillScreen,
            reserved: topPadding + bottomPadding,
            child: ContentContainer(
              child: Reveal(
                offsetY: 20,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _Wordmark(
                    width: wordmarkWidth,
                    aspectRatio: 1600 / 961,
                    topTrim: 0.008,
                    bottomTrim: 0.005,
                  ),
                  if (hasSentence) ...<Widget>[
                    SizedBox(
                      height: responsive<double>(size,
                          mobile: 0, tablet: 2, desktop: 4),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: ledeWidth),
                      child: HeroSentence(
                        text: profile.heroSentence,
                        style: AppText.lede.copyWith(
                          fontSize: ledeSize,
                          height: 1.6,
                        ),
                        accentStyle: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: responsive<double>(size,
                        mobile: 10, tablet: 12, desktop: 14),
                  ),
                  Image.asset(
                    'assets/images/amar-logo.webp',
                    width: responsive<double>(size,
                        mobile: 118, tablet: 132, desktop: 146),
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    semanticLabel: profile.signature,
                  ),
                  if (profile.subrole.trim().isNotEmpty) ...<Widget>[
                    SizedBox(
                      height: responsive<double>(size,
                          mobile: 9, tablet: 10, desktop: 11),
                    ),
                    _Subrole(
                      label: profile.subrole,
                      fontSize: responsive<double>(size,
                          mobile: 10.5, tablet: 11.5, desktop: 12.5),
                    ),
                  ],
                  SizedBox(
                    height: responsive<double>(size,
                        mobile: 17, tablet: 19, desktop: 21),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      PillButton(label: 'Mes projets', onTap: onProjects),
                      PillButton(
                        label: 'Me contacter',
                        variant: PillVariant.ghost,
                        onTap: onContact,
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Subrole extends StatelessWidget {
  const _Subrole({required this.label, required this.fontSize});

  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = AppText.subrole(fontSize);
    return Padding(
      padding: EdgeInsets.only(left: style.letterSpacing ?? 0),
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({
    required this.width,
    required this.aspectRatio,
    required this.topTrim,
    required this.bottomTrim,
  });

  final double width;
  final double aspectRatio;
  final double topTrim;
  final double bottomTrim;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double drawWidth =
            constraints.hasBoundedWidth && constraints.maxWidth < width
                ? constraints.maxWidth
                : width;
        final double height = drawWidth / aspectRatio;
        final double trimmed = topTrim + bottomTrim;
        final double alignY = trimmed <= 0 ? 0 : (2 * topTrim / trimmed) - 1;

        return SizedBox(
          width: drawWidth,
          height: height * (1 - trimmed),
          child: ClipRect(
            child: OverflowBox(
              minWidth: drawWidth,
              maxWidth: drawWidth,
              minHeight: height,
              maxHeight: height,
              alignment: Alignment(0, alignY),
              child: Image.asset(
                'assets/images/portfolio-wordmark.webp',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                semanticLabel: 'Portfolio',
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FillScreen extends StatelessWidget {
  const _FillScreen({
    required this.enabled,
    required this.reserved,
    required this.child,
  });

  final bool enabled;
  final double reserved;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final double available =
        (MediaQuery.sizeOf(context).height - reserved).clamp(360.0, 1200.0);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: available),
      child: Align(
        alignment: const Alignment(0, -0.12),
        child: child,
      ),
    );
  }
}
