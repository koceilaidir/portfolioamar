import 'package:flutter/material.dart';

class HandwrittenSignature extends StatefulWidget {
  const HandwrittenSignature({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 1450),
    this.delay = const Duration(milliseconds: 400),
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle style;
  final Duration duration;
  final Duration delay;
  final TextAlign textAlign;

  @override
  State<HandwrittenSignature> createState() => _HandwrittenSignatureState();
}

class _HandwrittenSignatureState extends State<HandwrittenSignature>
    with SingleTickerProviderStateMixin {
  static const double _softEdge = 0.022;
  static const double _crossShare = 0.62;
  static const double _minWeight = 0.55;
  static const double _widthWeight = 7.0;
  static const double _spaceWeight = 1.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  List<double> _bounds = <double>[0, 1];
  List<double> _times = <double>[0, 1];
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _measure();
    if (!_started) {
      _started = true;
      _start();
    }
  }

  @override
  void didUpdateWidget(HandwrittenSignature oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _measure();
      if (oldWidget.text != widget.text) {
        _controller.reset();
        _start();
      }
    }
  }

  void _measure() {
    final String text = widget.text;
    if (text.isEmpty) return;

    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: widget.style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    final double width = painter.width;
    if (width <= 0) {
      painter.dispose();
      return;
    }

    final List<double> bounds = <double>[0];
    for (int i = 1; i <= text.length; i++) {
      final double dx = painter
          .getOffsetForCaret(TextPosition(offset: i), Rect.zero)
          .dx;
      bounds.add((dx / width).clamp(0.0, 1.0));
    }
    painter.dispose();

    final List<double> weights = <double>[];
    double total = 0;
    for (int i = 0; i < text.length; i++) {
      final double span = (bounds[i + 1] - bounds[i]).clamp(0.0, 1.0);
      final double weight = text[i] == ' '
          ? _spaceWeight
          : _minWeight + span * _widthWeight;
      weights.add(weight);
      total += weight;
    }
    if (total <= 0) return;

    final List<double> times = <double>[0];
    double acc = 0;
    for (final double weight in weights) {
      acc += weight;
      times.add(acc / total);
    }

    _bounds = bounds;
    _times = times;
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) _controller.forward();
  }

  double _edgeAt(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return 1;
    for (int i = 0; i < _times.length - 1; i++) {
      final double start = _times[i];
      final double end = _times[i + 1];
      if (t > end) continue;
      final double slice = end - start;
      if (slice <= 0) return _bounds[i + 1];
      final double local = (t - start) / slice;
      final double crossed = (local / _crossShare).clamp(0.0, 1.0);
      final double eased = Curves.easeOutSine.transform(crossed);
      return _bounds[i] + (_bounds[i + 1] - _bounds[i]) * eased;
    }
    return 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double edge = _edgeAt(_controller.value);
        final double inked = (edge - _softEdge).clamp(0.0, 1.0);
        final double front = edge.clamp(inked, 1.0);

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: const Alignment(-1, -0.25),
              end: const Alignment(1, 0.25),
              colors: const <Color>[
                Colors.black,
                Colors.black,
                Colors.transparent,
                Colors.transparent,
              ],
              stops: <double>[0, inked, front, 1],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        textAlign: widget.textAlign,
        style: widget.style,
      ),
    );
  }
}
