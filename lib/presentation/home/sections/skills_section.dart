import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/section_heading.dart';
import '../../widgets/skill_bar.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
    required this.copy,
    required this.skills,
    required this.quote,
  });

  final SectionCopy copy;
  final List<Skill> skills;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool wide = size != ScreenSize.mobile;

    return Padding(
      padding: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 56, desktop: 80),
      ),
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Reveal(child: SectionHeading(copy: copy)),
            const SizedBox(height: 22),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: quote.trim().isEmpty
                        ? const SizedBox.shrink()
                        : _QuoteBlock(quote: quote, size: size),
                  ),
                  const SizedBox(width: 56),
                  Expanded(flex: 6, child: _SkillList(skills: skills)),
                ],
              )
            else ...<Widget>[
              _SkillList(skills: skills),
              if (quote.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 22),
                _QuoteBlock(quote: quote, size: size),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SkillList extends StatelessWidget {
  const _SkillList({required this.skills});

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < skills.length; i++)
          Reveal(
            offsetY: 14,
            delay: Duration(milliseconds: 90 * i),
            child: SkillBar(skill: skills[i]),
          ),
      ],
    );
  }
}

class _QuoteBlock extends StatelessWidget {
  const _QuoteBlock({required this.quote, required this.size});

  final String quote;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    final double fontSize =
        responsive<double>(size, mobile: 19, tablet: 21, desktop: 23);

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '"',
            style: AppText.quote(fontSize * 2).copyWith(
              color: AppColors.primary,
              height: 0.7,
            ),
          ),
          SizedBox(height: fontSize * 0.24),
          Text(quote, style: AppText.quote(fontSize)),
        ],
      ),
    );
  }
}
