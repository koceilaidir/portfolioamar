import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/hover_region.dart';
import '../../data/models/portfolio_content.dart';

Future<void> showPhotoViewer(
  BuildContext context, {
  required List<ProjectPhoto> photos,
  required int index,
}) {
  if (photos.isEmpty) return Future<void>.value();
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      barrierLabel: 'Fermer la photo',
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondary) =>
          _PhotoViewer(
        photos: photos,
        initialIndex: index.clamp(0, photos.length - 1),
      ),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondary, Widget child) {
        final CurvedAnimation curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curve),
            child: child,
          ),
        );
      },
    ),
  );
}

class _PhotoViewer extends StatefulWidget {
  const _PhotoViewer({required this.photos, required this.initialIndex});

  final List<ProjectPhoto> photos;
  final int initialIndex;

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late final PageController _pages =
      PageController(initialPage: widget.initialIndex);
  final FocusNode _focus = FocusNode();
  final TransformationController _zoom = TransformationController();

  late int _index = widget.initialIndex;
  late int _target = widget.initialIndex;
  bool _closing = false;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _zoom.addListener(_handleZoom);
  }

  void _handleZoom() {
    final bool zoomed = _zoom.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed == _zoomed) return;
    setState(() => _zoomed = zoomed);
  }

  void _close() {
    if (_closing) return;
    _closing = true;
    Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    _zoom.removeListener(_handleZoom);
    _zoom.dispose();
    _pages.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _go(int delta) {
    if (!_pages.hasClients) return;
    final int target =
        (_target + delta).clamp(0, widget.photos.length - 1);
    if (target == _target) return;
    _target = target;
    _zoom.value = Matrix4.identity();
    _pages.animateToPage(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _go(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _go(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final bool wide = size != ScreenSize.mobile;
    final ProjectPhoto current = widget.photos[_index];
    final double edge = responsive<double>(size, mobile: 14, tablet: 22, desktop: 30);

    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: AppColors.ink.withValues(alpha: 0.94),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  wide ? 84 : edge,
                  edge + 46,
                  wide ? 84 : edge,
                  edge + 54,
                ),
                child: PageView.builder(
                  controller: _pages,
                  itemCount: widget.photos.length,
                  physics: _zoomed
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
                  onPageChanged: (int value) => setState(() {
                    _index = value;
                    _target = value;
                  }),
                  itemBuilder: (BuildContext context, int i) {
                    return _Frame(
                      photo: widget.photos[i],
                      controller: i == _index ? _zoom : null,
                      onDismiss: _close,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: edge,
              left: edge,
              child: IgnorePointer(
                child: Text(
                  '${_index + 1} / ${widget.photos.length}',
                  style: AppText.kicker.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
            Positioned(
              top: edge - 8,
              right: edge - 8,
              child: _RoundButton(
                icon: Icons.close_rounded,
                tooltip: 'Fermer',
                onTap: _close,
              ),
            ),
            if (wide && widget.photos.length > 1) ...<Widget>[
              Positioned(
                left: edge - 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _RoundButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Photo précédente',
                    onTap: _index == 0 ? null : () => _go(-1),
                  ),
                ),
              ),
              Positioned(
                right: edge - 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _RoundButton(
                    icon: Icons.arrow_forward_rounded,
                    tooltip: 'Photo suivante',
                    onTap: _index == widget.photos.length - 1
                        ? null
                        : () => _go(1),
                  ),
                ),
              ),
            ],
            if (current.caption.isNotEmpty)
              Positioned(
                left: edge,
                right: edge,
                bottom: edge,
                child: IgnorePointer(
                  child: Text(
                    current.caption,
                    textAlign: TextAlign.center,
                    style: AppText.footerRow.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.cream.withValues(alpha: 0.82),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.photo,
    required this.onDismiss,
    this.controller,
  });

  final ProjectPhoto photo;
  final VoidCallback onDismiss;
  final TransformationController? controller;

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.network(
      photo.url,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryLight,
            ),
          ),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          Center(
        child: Text(
          'Photo indisponible',
          style: AppText.footerRow.copyWith(color: AppColors.cream),
        ),
      ),
    );

    return InteractiveViewer(
      transformationController: controller,
      minScale: 1,
      maxScale: 4,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: image,
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: HoverRegion(
        onTap: onTap,
        builder: (BuildContext context, bool hovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hovered && enabled
                  ? AppColors.primary
                  : AppColors.cream.withValues(alpha: 0.10),
              border: Border.all(
                color: AppColors.cream.withValues(alpha: enabled ? 0.28 : 0.10),
              ),
            ),
            child: Icon(
              icon,
              size: 19,
              color: AppColors.cream
                  .withValues(alpha: enabled ? (hovered ? 1 : 0.85) : 0.25),
            ),
          );
        },
      ),
    );
  }
}
