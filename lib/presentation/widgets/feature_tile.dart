import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/portfolio_content.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({super.key, required this.feature});

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            AppIcons.resolve(feature.iconKey),
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                feature.title.toUpperCase(),
                style: AppText.featureTitle,
              ),
              const SizedBox(height: 2),
              Text(
                feature.description,
                style: AppText.featureBody,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
