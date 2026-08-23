import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/project_card.dart';
import '../../widgets/section_heading.dart';

/// Section "Selected Projects" — `.sec` + `.projects`.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({
    super.key,
    required this.copy,
    required this.projects,
    this.onSeeAll,
    this.onProjectTap,
  });

  final SectionCopy copy;
  final List<Project> projects;
  final VoidCallback? onSeeAll;
  final void Function(Project project)? onProjectTap;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final int columns = responsive<int>(size, mobile: 1, tablet: 2, desktop: 2);
    const double gap = 18;

    return Padding(
      padding: EdgeInsets.only(
        top: responsive<double>(size, mobile: 34, tablet: 56, desktop: 80),
      ),
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Reveal(child: SectionHeading(copy: copy, onLinkTap: onSeeAll)),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double cardWidth = columns == 1
                    ? constraints.maxWidth
                    : (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: <Widget>[
                    for (int i = 0; i < projects.length; i++)
                      SizedBox(
                        width: cardWidth,
                        child: Reveal(
                          delay: Duration(milliseconds: 70 * (i % columns)),
                          child: ProjectCard(
                            project: projects[i],
                            index: i + 1,
                            onTap: onProjectTap == null
                                ? null
                                : () => onProjectTap!(projects[i]),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
