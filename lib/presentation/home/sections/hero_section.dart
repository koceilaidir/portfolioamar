import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/grid_fade.dart';
import '../../widgets/handwritten_signature.dart';
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

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: responsive<double>(size, mobile: 34, tablet: 54, desktop: 74),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GridFade(
              cell: responsive<double>(size, mobile: 26, tablet: 30, desktop: 34),
              center: const Alignment(0, -0.1),
            ),
          ),
          ContentContainer(
            child: Reveal(
              offsetY: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: wordmarkWidth,
                    child: AspectRatio(
                      aspectRatio: 1600 / 1018,
                      child: Image.asset(
                        'assets/images/portfolio-wordmark.webp',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        semanticLabel: 'Portfolio',
                      ),
                    ),
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
                  HandwrittenSignature(
                    text: profile.signature,
                    style: AppText.signature(
                      responsive<double>(size,
                          mobile: 29, tablet: 32, desktop: 36),
                    ),
                  ),
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
        ],
      ),
    );
  }
}
