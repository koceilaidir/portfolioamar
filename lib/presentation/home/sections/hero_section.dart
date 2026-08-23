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
    final double fontSize =
        responsive<double>(size, mobile: 32, tablet: 54, desktop: 74);
    final double sentenceWidth =
        responsive<double>(size, mobile: 560, tablet: 780, desktop: 1020);
    final double minHeight =
        (MediaQuery.sizeOf(context).height - topPadding).clamp(440.0, 880.0);

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: responsive<double>(size, mobile: 30, tablet: 50, desktop: 70),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GridFade(
              cell: responsive<double>(size, mobile: 26, tablet: 30, desktop: 34),
              center: const Alignment(0, -0.1),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Center(
              child: ContentContainer(
                child: Reveal(
                  offsetY: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _Kicker(label: profile.subrole),
                      SizedBox(
                        height: responsive<double>(size,
                            mobile: 22, tablet: 30, desktop: 34),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: sentenceWidth),
                        child: HeroSentence(
                          text: profile.heroSentence,
                          fontSize: fontSize,
                        ),
                      ),
                      SizedBox(
                        height: responsive<double>(size,
                            mobile: 24, tablet: 30, desktop: 34),
                      ),
                      Text(
                        profile.signature,
                        textAlign: TextAlign.center,
                        style: AppText.signature(
                          responsive<double>(size,
                              mobile: 30, tablet: 34, desktop: 38),
                        ),
                      ),
                      SizedBox(
                        height: responsive<double>(size,
                            mobile: 20, tablet: 24, desktop: 28),
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
          ),
        ],
      ),
    );
  }
}

class _Kicker extends StatelessWidget {
  const _Kicker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: AppText.kicker,
      ),
    );
  }
}
