import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract final class Breakpoints {
  static const double tablet = 760;
  static const double desktop = 1100;

  static const double maxContentWidth = 1160;

  static ScreenSize of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }

  static ScreenSize fromWidth(double width) {
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  static double gutter(ScreenSize size) {
    switch (size) {
      case ScreenSize.mobile:
        return 22;
      case ScreenSize.tablet:
        return 40;
      case ScreenSize.desktop:
        return 56;
    }
  }
}

T responsive<T>(
  ScreenSize size, {
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  switch (size) {
    case ScreenSize.mobile:
      return mobile;
    case ScreenSize.tablet:
      return tablet ?? mobile;
    case ScreenSize.desktop:
      return desktop ?? tablet ?? mobile;
  }
}

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.horizontalPadding,
  });

  final Widget child;
  final double maxWidth;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final double padding = horizontalPadding ?? Breakpoints.gutter(size);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth + padding * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: child,
        ),
      ),
    );
  }
}
