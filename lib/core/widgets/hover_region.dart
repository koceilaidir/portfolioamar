import 'package:flutter/material.dart';

/// Petit utilitaire : expose un état "survolé" à son builder et affiche le
/// curseur main quand un [onTap] est fourni.
class HoverRegion extends StatefulWidget {
  const HoverRegion({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  @override
  State<HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<HoverRegion> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = MouseRegion(
      cursor: widget.cursor ??
          (widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer),
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: widget.builder(context, _hovered),
    );

    if (widget.onTap == null) return content;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
