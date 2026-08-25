import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class HeroSentence extends StatelessWidget {
  const HeroSentence({
    super.key,
    required this.text,
    required this.style,
    this.accentStyle,
    this.dotSize,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle style;
  final TextStyle? accentStyle;
  final double? dotSize;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final double? dot = dotSize;
    final String source =
        dot == null ? text.replaceAll(RegExp(r'\s*•\s*'), ' ') : text;

    final List<InlineSpan> spans = <InlineSpan>[];
    final StringBuffer buffer = StringBuffer();
    bool accent = false;
    int dotIndex = 0;

    void flush() {
      if (buffer.isEmpty) return;
      spans.add(
        TextSpan(
          text: buffer.toString(),
          style: accent
              ? (accentStyle ?? const TextStyle(color: AppColors.primary))
              : null,
        ),
      );
      buffer.clear();
    }

    for (final int rune in source.runes) {
      final String char = String.fromCharCode(rune);
      if (char == '*') {
        flush();
        accent = !accent;
      } else if (char == '•' && dot != null) {
        flush();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _FloatingDot(size: dot, index: dotIndex),
          ),
        );
        dotIndex++;
      } else {
        buffer.write(char);
      }
    }
    flush();

    return Text.rich(
      TextSpan(children: spans),
      textAlign: textAlign,
      style: style,
    );
  }
}

class _FloatingDot extends StatefulWidget {
  const _FloatingDot({required this.size, required this.index});

  final double size;
  final int index;

  @override
  State<_FloatingDot> createState() => _FloatingDotState();
}

class _FloatingDotState extends State<_FloatingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 3400 + widget.index * 600),
  )..repeat(reverse: true);

  late final Animation<double> _float = _controller.drive(
    Tween<double>(begin: 0, end: -1).chain(CurveTween(curve: Curves.easeInOut)),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size * 0.28),
      child: AnimatedBuilder(
        animation: _float,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, _float.value * widget.size * 0.18),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
