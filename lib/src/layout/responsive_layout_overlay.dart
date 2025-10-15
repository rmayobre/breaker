import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';

enum OverlayType {
  horizontal,
  vertical;
}

final class ResponsiveLayoutOverlay extends StatelessWidget {

  const ResponsiveLayoutOverlay({
    super.key,
    this.type = OverlayType.vertical,
    this.spanColor = const Color(defaultSpanColor),
    this.marginColor = const Color(defaultMarginColor),
    this.spacingColor = const Color(defaultSpacingColor),
    this.opacity = 0.7,
    required this.constraints,
    required this.child,
  });
  
  static const int defaultSpanColor = 0xFFF44336;
  static const int defaultMarginColor = 0xFF4CAF50;
  static const int defaultSpacingColor = 0xFF00BCD4;
  static const double _overlayOpacity = 0.2;

  final Color spanColor;

  final Color marginColor;

  final Color spacingColor;

  final double opacity;

  final OverlayType type;

  final LayoutConstraints constraints;

  final Widget child;

  @override
  Widget build(BuildContext context) { // TODO support horizontal
    final List<Widget> spansAndSpaces = [];
    for (var i = 0; i < constraints.axes; i++) {
      spansAndSpaces.add(
          ColoredBox(
            color: spanColor.withValues(alpha: _overlayOpacity),
            child: SizedBox(width: constraints.axisSize, height: double.infinity),
          )
      );
      if (i < constraints.axes - 1) {
        spansAndSpaces.add(
            ColoredBox(
              color: spacingColor.withValues(alpha: _overlayOpacity),
              child: SizedBox(width: constraints.spacing, height: double.infinity),
            )
        );
      }
    }
    return Stack(
      children: [
        Row(
          children: [
            ColoredBox(
              color: marginColor.withValues(alpha: _overlayOpacity),
              child: SizedBox(width: constraints.margin, height: double.infinity),
            ),
            ...spansAndSpaces,
            ColoredBox(
              color: marginColor.withValues(alpha: _overlayOpacity),
              child: SizedBox(width: constraints.margin, height: double.infinity),
            ),
          ],
        ),
        Opacity(opacity: opacity, child: child),
      ],
    );
  }
}
