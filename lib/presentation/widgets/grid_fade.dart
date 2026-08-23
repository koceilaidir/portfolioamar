import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Grille très légère qui s'estompe sur les bords — équivalent de `.grid-fade`.
class GridFade extends StatelessWidget {
  const GridFade({super.key, this.cell = 26, this.center = const Alignment(0, -0.4)});

  final double cell;
  final Alignment center;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            center: center,
            radius: 0.95,
            colors: const <Color>[Colors.black, Colors.transparent],
            stops: const <double>[0.0, 0.85],
          ).createShader(bounds);
        },
        child: CustomPaint(
          painter: _GridPainter(cell: cell),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.cell});

  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.gridLine
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.cell != cell;
}
