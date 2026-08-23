import 'package:flutter/material.dart';

/// Diffuse la position de défilement de la page à tous les widgets [Reveal]
/// sans provoquer de reconstruction générale : chaque [Reveal] s'abonne
/// lui-même au notifier et s'en désabonne dès qu'il est apparu.
class ScrollOffsetProvider extends InheritedWidget {
  const ScrollOffsetProvider({
    super.key,
    required this.offset,
    required super.child,
  });

  final ValueNotifier<double> offset;

  static ValueNotifier<double>? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<ScrollOffsetProvider>()
        ?.offset;
  }

  @override
  bool updateShouldNotify(ScrollOffsetProvider oldWidget) =>
      oldWidget.offset != offset;
}

/// Expose l'animation d'apparition du [Reveal] parent afin que des enfants
/// (barres de compétences, compteurs…) puissent se caler dessus.
class RevealAnimation extends InheritedWidget {
  const RevealAnimation({
    super.key,
    required this.animation,
    required super.child,
  });

  final Animation<double> animation;

  static Animation<double>? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RevealAnimation>()?.animation;
  }

  @override
  bool updateShouldNotify(RevealAnimation oldWidget) =>
      oldWidget.animation != animation;
}

/// Fait apparaître son enfant (fondu + léger glissement vers le haut)
/// la première fois qu'il entre dans la zone visible.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.offsetY = 26,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  ValueNotifier<double>? _scrollOffset;
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ValueNotifier<double>? notifier = ScrollOffsetProvider.maybeOf(context);
    if (notifier != _scrollOffset) {
      _scrollOffset?.removeListener(_maybeReveal);
      _scrollOffset = notifier;
      if (!_triggered) {
        _scrollOffset?.addListener(_maybeReveal);
      }
    }
    if (notifier == null) {
      // Pas de scroll observé (tests, aperçus) : on affiche directement.
      _start();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeReveal());
    }
  }

  void _maybeReveal() {
    if (_triggered || !mounted) return;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached || !renderObject.hasSize) {
      return;
    }
    final double viewportHeight = MediaQuery.sizeOf(context).height;
    final double top = renderObject.localToGlobal(Offset.zero).dy;
    if (top < viewportHeight - 40) {
      _start();
    }
  }

  Future<void> _start() async {
    if (_triggered) return;
    _triggered = true;
    _scrollOffset?.removeListener(_maybeReveal);
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _scrollOffset?.removeListener(_maybeReveal);
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RevealAnimation(
      animation: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _curve.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, widget.offsetY * (1 - _curve.value)),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
