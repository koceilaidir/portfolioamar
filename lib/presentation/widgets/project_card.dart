import 'package:flutter/material.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/hover_region.dart';
import '../../data/models/portfolio_content.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    this.onTap,
  });

  final Project project;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final double thumbHeight =
        responsive<double>(size, mobile: 150, tablet: 190, desktop: 230);
    final double labelSize =
        responsive<double>(size, mobile: 20, tablet: 24, desktop: 27);

    return HoverRegion(
      onTap: onTap,
      cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      builder: (BuildContext context, bool hovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(18),
            boxShadow: hovered
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x1F20201C),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: thumbHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AnimatedScale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        scale: hovered ? 1.06 : 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: project.gradient,
                                ),
                              ),
                            ),
                            if (project.imageUrl != null)
                              Image.network(
                                project.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stack) =>
                                    const SizedBox.shrink(),
                              ),

                            if (project.imageUrl != null)
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color(0x0020201C),
                                      Color(0x9920201C),
                                    ],
                                    stops: <double>[0.45, 1],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            project.thumbnailLabel,
                            style: AppText.projectThumb(labelSize).copyWith(
                              color: project.imageUrl != null
                                  ? Colors.white
                                  : project.thumbnailTextColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 240),
                          opacity: hovered && onTap != null ? 1 : 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.terracotta,
                            ),
                            child: const Icon(
                              Icons.north_east_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        index.toString().padLeft(2, '0'),
                        style: AppText.projectNumber,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              project.title,
                              style: AppText.projectTitle.copyWith(
                                color: hovered
                                    ? AppColors.terracottaDeep
                                    : AppColors.ink,
                              ),
                            ),
                            Text(
                              project.subtitle,
                              style: AppText.projectSubtitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
