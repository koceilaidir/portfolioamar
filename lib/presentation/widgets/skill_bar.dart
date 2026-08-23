import 'package:flutter/material.dart';

import '../../core/animation/reveal.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/portfolio_content.dart';

/// Ligne de compétence — `.skill-row`, `.bar`, `.pct`.
/// La barre se remplit en même temps que le [Reveal] parent apparaît.
class SkillBar extends StatelessWidget {
  const SkillBar({super.key, required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final Animation<double>? reveal = RevealAnimation.maybeOf(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: responsive<double>(size, mobile: 120, tablet: 140, desktop: 150),
            child: Text(
              skill.label.toUpperCase(),
              style: AppText.skillLabel,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.creamAlt,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: reveal == null
                      ? _Fill(widthFactor: skill.fraction)
                      : AnimatedBuilder(
                          animation: reveal,
                          builder: (BuildContext context, Widget? child) {
                            return _Fill(
                              widthFactor:
                                  skill.fraction * reveal.value.clamp(0.0, 1.0),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 34,
            child: Text(
              '${skill.level}%',
              textAlign: TextAlign.right,
              style: AppText.skillValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor.clamp(0.0, 1.0),
      heightFactor: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.terracotta,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
