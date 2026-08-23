import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/review_form.dart';
import '../../widgets/section_heading.dart';
import '../../widgets/testimonial_card.dart';

/// Section "What Clients Say" — `.testi`.
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({
    super.key,
    required this.copy,
    required this.testimonials,
    this.onSubmitReview,
  });

  final SectionCopy copy;
  final List<Testimonial> testimonials;

  /// Non null quand le back accepte les avis de visiteurs.
  final ReviewSubmitter? onSubmitReview;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool wide = size != ScreenSize.mobile;
    const double gap = 14;

    return Padding(
      padding: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 56, desktop: 80),
      ),
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Reveal(child: SectionHeading(copy: copy)),
            const SizedBox(height: 20),
            if (testimonials.isNotEmpty)
              if (wide)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (int i = 0; i < testimonials.length; i++) ...<Widget>[
                        if (i > 0) const SizedBox(width: gap),
                        Expanded(
                          child: Reveal(
                            delay: Duration(milliseconds: 90 * i),
                            child: TestimonialCard(testimonial: testimonials[i]),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    for (int i = 0; i < testimonials.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == testimonials.length - 1 ? 0 : gap,
                        ),
                        child: Reveal(
                          delay: Duration(milliseconds: 90 * i),
                          child: TestimonialCard(testimonial: testimonials[i]),
                        ),
                      ),
                  ],
                ),
            if (onSubmitReview != null) ...<Widget>[
              SizedBox(height: testimonials.isEmpty ? 4 : 18),
              Reveal(
                offsetY: 14,
                child: PillButton(
                  label: 'Laisser un avis',
                  variant: PillVariant.ghost,
                  onTap: () =>
                      ReviewFormDialog.show(context, onSubmitReview!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
