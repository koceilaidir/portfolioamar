import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/portfolio_content.dart';
import 'grid_fade.dart';

class SoftwareCloud extends StatelessWidget {
  const SoftwareCloud({super.key, required this.skills});

  static const List<Alignment> _spots = <Alignment>[
    Alignment(-0.74, -0.66),
    Alignment(0.22, -0.90),
    Alignment(0.88, -0.42),
    Alignment(-0.10, -0.06),
    Alignment(-0.94, 0.30),
    Alignment(0.66, 0.30),
    Alignment(0.08, 0.82),
    Alignment(0.92, 0.92),
    Alignment(-0.60, 0.88),
  ];

  static const double _spread = 0.80;

  static const double _boxRatio = 1.15;

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();
    final int count = math.min(skills.length, _spots.length);

    return AspectRatio(
      aspectRatio: _boxRatio,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double base = (constraints.maxWidth * 0.135).clamp(38.0, 74.0);
          return Stack(
            children: <Widget>[
              const Positioned.fill(
                child: GridFade(cell: 30, center: Alignment(0, 0)),
              ),
              for (int i = 0; i < count; i++)
                Align(
                  alignment: Alignment(
                    _spots[i].x * _spread,
                    _spots[i].y * _spread,
                  ),
                  child: _FloatingBadge(
                    skill: skills[i],
                    index: i,
                    size: base * (0.80 + 0.20 * skills[i].fraction),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingBadge extends StatefulWidget {
  const _FloatingBadge({
    required this.skill,
    required this.index,
    required this.size,
  });

  final Skill skill;
  final int index;
  final double size;

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 3200 + widget.index * 430),
  );

  late final Animation<double> _float = _controller.drive(
    Tween<double>(begin: -1, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutSine)),
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future<void>.delayed(Duration(milliseconds: widget.index * 180));
    if (mounted) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAccent => widget.index == 0;

  bool get _isInk => widget.index % 3 == 2;

  @override
  Widget build(BuildContext context) {
    final double side = widget.size;
    final Color background = _isAccent
        ? AppColors.primary
        : _isInk
            ? AppColors.ink
            : AppColors.card;
    final Color foreground = _isAccent
        ? Colors.white
        : _isInk
            ? AppColors.cream
            : AppColors.ink;

    return Tooltip(
      message: widget.skill.label,
      waitDuration: const Duration(milliseconds: 400),
      child: AnimatedBuilder(
        animation: _float,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, _float.value * side * 0.07),
            child: Transform.rotate(
              angle: _float.value * 0.035,
              child: child,
            ),
          );
        },
        child: Container(
          width: side,
          height: side,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: _isAccent || _isInk ? Colors.transparent : AppColors.line,
            ),
            borderRadius: BorderRadius.circular(side * 0.28),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _isAccent
                    ? AppColors.buttonShadow
                    : const Color(0x1A20201C),
                blurRadius: side * 0.32,
                offset: Offset(0, side * 0.11),
              ),
            ],
          ),
          child: Text(
            widget.skill.badge,
            style: AppText.softwareBadge(side * 0.34).copyWith(
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}
