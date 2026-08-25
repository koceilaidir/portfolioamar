import 'package:flutter/material.dart';

class LogoSignature extends StatefulWidget {
  const LogoSignature({
    super.key,
    required this.width,
    this.duration = const Duration(milliseconds: 1250),
    this.delay = const Duration(milliseconds: 350),
  });

  static const double aspectRatio = 942 / 608.45;

  final double width;
  final Duration duration;
  final Duration delay;

  @override
  State<LogoSignature> createState() => _LogoSignatureState();
}

class _LogoSignatureState extends State<LogoSignature>
    with SingleTickerProviderStateMixin {
  static const double _strokeEnd = 0.58;
  static const double _wordStart = 0.46;
  static const double _softEdge = 0.07;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  bool _started = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    if (_started) return;
    _started = true;
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _strokeProgress(double t) {
    final double raw = (t / _strokeEnd).clamp(0.0, 1.0);
    return Curves.easeInOutSine.transform(raw);
  }

  double _wordProgress(double t) {
    final double raw = ((t - _wordStart) / (1 - _wordStart)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(raw);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: AspectRatio(
        aspectRatio: LogoSignature.aspectRatio,
        child: Semantics(
          label: 'Amar',
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              final double t = _controller.value;
              final double edge = _strokeProgress(t);
              final double word = _wordProgress(t);
              final double inked = (edge - _softEdge).clamp(0.0, 1.0);
              final double front = edge.clamp(inked, 1.0);

              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: const Alignment(-1, -0.35),
                        end: const Alignment(1, 0.35),
                        colors: const <Color>[
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: <double>[0, inked, front, 1],
                      ).createShader(bounds);
                    },
                    child: const _Layer(asset: 'amar-logo-stroke'),
                  ),
                  Opacity(
                    opacity: word,
                    child: Transform.translate(
                      offset: Offset(0, (1 - word) * widget.width * 0.035),
                      child: const _Layer(asset: 'amar-logo-word'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Layer extends StatelessWidget {
  const _Layer({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$asset.webp',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
