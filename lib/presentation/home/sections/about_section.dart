import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/hero_sentence.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.about});

  final AboutInfo about;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool wide = size != ScreenSize.mobile;
    final List<String> paragraphs = about.paragraphs;
    final bool hasSteps = about.steps.isNotEmpty;

    final Widget narrative = _Narrative(
      paragraphs: paragraphs,
      tags: about.tags,
      size: size,
    );
    final Widget steps = _Steps(steps: about.steps, size: size);

    return Padding(
      padding: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 56, desktop: 80),
      ),
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (about.kicker.trim().isNotEmpty)
                    _Kicker(label: about.kicker),
                  if (about.title.trim().isNotEmpty) ...<Widget>[
                    SizedBox(
                      height:
                          responsive<double>(size, mobile: 12, tablet: 14, desktop: 16),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive<double>(size,
                            mobile: 520, tablet: 600, desktop: 680),
                      ),
                      child: HeroSentence(
                        text: about.title,
                        textAlign: TextAlign.start,
                        style: AppText.sectionKicker(
                          responsive<double>(size,
                              mobile: 25, tablet: 31, desktop: 38),
                        ),
                        accentStyle: const TextStyle(
                          color: AppColors.primaryDeep,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (about.quote.trim().isNotEmpty) ...<Widget>[
              SizedBox(
                height: responsive<double>(size, mobile: 20, tablet: 26, desktop: 30),
              ),
              Reveal(
                offsetY: 18,
                child: _QuoteCard(quote: about.quote, size: size),
              ),
            ],
            if (about.kicker.trim().isNotEmpty ||
                about.title.trim().isNotEmpty ||
                about.quote.trim().isNotEmpty)
              SizedBox(
                height:
                    responsive<double>(size, mobile: 24, tablet: 30, desktop: 34),
              ),
            if (wide && hasSteps)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 6, child: narrative),
                  SizedBox(
                    width: responsive<double>(size, mobile: 0, tablet: 40, desktop: 56),
                  ),
                  Expanded(flex: 5, child: steps),
                ],
              )
            else ...<Widget>[
              narrative,
              if (hasSteps) ...<Widget>[
                SizedBox(
                  height:
                      responsive<double>(size, mobile: 26, tablet: 30, desktop: 34),
                ),
                steps,
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _Kicker extends StatelessWidget {
  const _Kicker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 26,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 9),
        Text(label.toUpperCase(), style: AppText.kicker),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.size});

  final String quote;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    final double fontSize =
        responsive<double>(size, mobile: 17, tablet: 19, desktop: 21);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: responsive<double>(size, mobile: 20, tablet: 28, desktop: 32),
        vertical: responsive<double>(size, mobile: 20, tablet: 26, desktop: 28),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '"',
            style: AppText.sectionKicker(fontSize * 2).copyWith(
              color: AppColors.primary,
              height: 0.7,
            ),
          ),
          Text(quote, style: AppText.quote(fontSize)),
        ],
      ),
    );
  }
}

class _Narrative extends StatelessWidget {
  const _Narrative({
    required this.paragraphs,
    required this.tags,
    required this.size,
  });

  final List<String> paragraphs;
  final List<String> tags;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    final double bodySize =
        responsive<double>(size, mobile: 13.5, tablet: 14, desktop: 15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == paragraphs.length - 1 ? 0 : 13),
            child: Reveal(
              offsetY: 16,
              delay: Duration(milliseconds: 70 * i),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                  child: HeroSentence(
                  text: paragraphs[i],
                  textAlign: TextAlign.start,
                  style: AppText.sectionDesc.copyWith(
                    fontSize: bodySize,
                    height: 1.72,
                  ),
                  accentStyle: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        if (tags.isNotEmpty) ...<Widget>[
          SizedBox(
            height: responsive<double>(size, mobile: 18, tablet: 22, desktop: 26),
          ),
          Reveal(
            offsetY: 14,
            child: Wrap(
              spacing: 9,
              runSpacing: 9,
              children: <Widget>[
                for (int i = 0; i < tags.length; i++)
                  _Tag(label: tags[i], filled: i == 0),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: filled ? AppColors.ink : AppColors.surface,
        border: Border.all(color: filled ? AppColors.ink : AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.kicker.copyWith(
          fontSize: 10,
          letterSpacing: 1.2,
          color: filled ? AppColors.cream : AppColors.inkSoft,
        ),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.steps, required this.size});

  final List<AboutStep> steps;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < steps.length; i++)
          Reveal(
            offsetY: 16,
            delay: Duration(milliseconds: 80 * i),
            child: _StepRow(
              index: i,
              step: steps[i],
              first: i == 0,
              size: size,
            ),
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.step,
    required this.first,
    required this.size,
  });

  final int index;
  final AboutStep step;
  final bool first;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    final double gap =
        responsive<double>(size, mobile: 14, tablet: 15, desktop: 17);

    return Container(
      padding: EdgeInsets.only(top: first ? 0 : gap, bottom: gap),
      decoration: BoxDecoration(
        border: first
            ? null
            : const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 32,
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                (index + 1).toString().padLeft(2, '0'),
                style: AppText.featureTitle.copyWith(
                  fontFamily: AppFonts.display,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(step.title.toUpperCase(), style: AppText.featureTitle),
                if (step.description.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 5),
                  Text(
                    step.description,
                    style: AppText.featureBody.copyWith(
                      fontSize: responsive<double>(size,
                          mobile: 12.5, tablet: 12.5, desktop: 13),
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
