import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';

/// The direction of the axes drawn by a [ResponsiveLayoutOverlay].
enum OverlayType { horizontal, vertical }

/// Draws the margins, axes and spacing of a layout behind [child] for
/// debugging.
///
/// Only [OverlayType.vertical] (columns) is currently drawn; [type] is
/// reserved for future horizontal support.
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

  /// Default color of the axes (red).
  static const int defaultSpanColor = 0xFFF44336;
  /// Default color of the margins (green).
  static const int defaultMarginColor = 0xFF4CAF50;
  /// Default color of the spacing between axes (cyan).
  static const int defaultSpacingColor = 0xFF00BCD4;
  static const double _overlayOpacity = 0.2;

  /// Color of the axes.
  final Color spanColor;

  /// Color of the margins.
  final Color marginColor;

  /// Color of the spacing between axes.
  final Color spacingColor;

  /// The opacity applied to [child], letting the overlay show through.
  final double opacity;

  /// The direction of the axes to draw.
  final OverlayType type;

  /// The resolved layout to visualize.
  final LayoutConstraints constraints;

  /// The content drawn on top of the overlay.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO support horizontal
    final List<Widget> spansAndSpaces = [];
    for (var i = 0; i < constraints.axes; i++) {
      spansAndSpaces.add(
        ColoredBox(
          color: spanColor.withValues(alpha: _overlayOpacity),
          child: SizedBox(width: constraints.axisSize, height: double.infinity),
        ),
      );
      if (i < constraints.axes - 1) {
        spansAndSpaces.add(
          ColoredBox(
            color: spacingColor.withValues(alpha: _overlayOpacity),
            child: SizedBox(
              width: constraints.spacing,
              height: double.infinity,
            ),
          ),
        );
      }
    }
    return Stack(
      children: [
        Row(
          children: [
            ColoredBox(
              color: marginColor.withValues(alpha: _overlayOpacity),
              child: SizedBox(
                width: constraints.margin,
                height: double.infinity,
              ),
            ),
            ...spansAndSpaces,
            ColoredBox(
              color: marginColor.withValues(alpha: _overlayOpacity),
              child: SizedBox(
                width: constraints.margin,
                height: double.infinity,
              ),
            ),
          ],
        ),
        Opacity(opacity: opacity, child: child),
      ],
    );
  }
}
