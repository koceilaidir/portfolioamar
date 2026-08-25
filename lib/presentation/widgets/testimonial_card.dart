import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/portfolio_content.dart';

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key, required this.testimonial});

  final Testimonial testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '"',
            style: AppText.quote(34).copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.normal,
              height: 0.7,
            ),
          ),
          const SizedBox(height: 8),
          Text(testimonial.quote, style: AppText.testimonial),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColors.primaryLight,
                      AppColors.primaryDeep,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(testimonial.author, style: AppText.testimonialName),
                    const SizedBox(height: 1),
                    Text(testimonial.authorRole,
                        style: AppText.testimonialRole),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
