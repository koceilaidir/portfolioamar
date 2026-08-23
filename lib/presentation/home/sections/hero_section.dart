import 'package:flutter/material.dart';

import '../../../core/animation/reveal.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/portfolio_content.dart';
import '../../widgets/grid_fade.dart';
import '../../widgets/pill_button.dart';

/// Section d'accueil — `.hero`.
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
    final bool isDesktop = size == ScreenSize.desktop;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding + responsive<double>(size, mobile: 8, tablet: 24, desktop: 36),
        bottom: responsive<double>(size, mobile: 26, tablet: 48, desktop: 72),
      ),
      child: ContentContainer(
        child: isDesktop ? _buildDesktop(context) : _buildCompact(context, size),
      ),
    );
  }

  // --- Mobile / tablette ----------------------------------------------------
  Widget _buildCompact(BuildContext context, ScreenSize size) {
    final double titleSize = responsive<double>(size, mobile: 66, tablet: 92);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: -10,
          left: -Breakpoints.gutter(size),
          right: -Breakpoints.gutter(size),
          height: responsive<double>(size, mobile: 150, tablet: 210),
          child: const GridFade(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: _FloatingTitle(
                text: profile.heroTitle,
                fontSize: titleSize,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            _HeroCopy(
              profile: profile,
              size: size,
              onProjects: onProjects,
              onContact: onContact,
            ),
          ],
        ),
      ],
    );
  }

  // --- Desktop --------------------------------------------------------------
  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 6,
          child: _HeroCopy(
            profile: profile,
            size: ScreenSize.desktop,
            onProjects: onProjects,
            onContact: onContact,
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 400,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Positioned.fill(child: GridFade(cell: 32)),
                _FloatingTitle(
                  text: profile.heroTitle,
                  fontSize: 104,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.profile,
    required this.size,
    required this.onProjects,
    required this.onContact,
  });

  final ProfileInfo profile;
  final ScreenSize size;
  final VoidCallback onProjects;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final double nameSize =
        responsive<double>(size, mobile: 46, tablet: 62, desktop: 74);
    final double ledeWidth =
        responsive<double>(size, mobile: 300, tablet: 440, desktop: 460);

    return Reveal(
      offsetY: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 6),
          Text(profile.greeting.toUpperCase(), style: AppText.hello),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: '${profile.firstName} '),
                TextSpan(
                  text: profile.lastName,
                  style: const TextStyle(color: AppColors.terracotta),
                ),
              ],
            ),
            style: AppText.name(nameSize),
          ),
          const SizedBox(height: 12),
          Text(profile.subrole.toUpperCase(), style: AppText.subrole),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ledeWidth),
            child: Text(
              profile.lede,
              style: AppText.lede.copyWith(
                fontSize: responsive<double>(size, mobile: 14, tablet: 15, desktop: 16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            profile.signature,
            style: AppText.signature(
              responsive<double>(size, mobile: 30, tablet: 34, desktop: 38),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              PillButton(
                label: 'Mes projets',
                onTap: onProjects,
              ),
              PillButton(
                label: 'Me contacter',
                variant: PillVariant.ghost,
                onTap: onContact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Titre "Portfolio" en lévitation — `@keyframes floatY`.
class _FloatingTitle extends StatefulWidget {
  const _FloatingTitle({
    required this.text,
    required this.fontSize,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final double fontSize;
  final TextAlign textAlign;

  @override
  State<_FloatingTitle> createState() => _FloatingTitleState();
}

class _FloatingTitleState extends State<_FloatingTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5000),
  )..repeat(reverse: true);

  late final Animation<double> _float = _controller.drive(
    Tween<double>(begin: 0, end: -8)
        .chain(CurveTween(curve: Curves.easeInOut)),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, _float.value),
          child: child,
        );
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: AppText.heroTitle(widget.fontSize).copyWith(
            shadows: const <Shadow>[
              Shadow(
                color: AppColors.titleGlow,
                offset: Offset(0, 10),
                blurRadius: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
