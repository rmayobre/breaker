import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';

/// The resolved measurements of a [LayoutBreakpoint] for a specific available
/// width: margin, axis size, axis count and spacing.
///
/// Passed to [ResponsiveLayoutBuilder] builders and to [AxisCalculator]s.
final class LayoutConstraints {
  /// Creates layout constraints from already-resolved values.
  const LayoutConstraints({
    this.body,
    required this.axes,
    required this.axisSize,
    required this.margin,
    required this.spacing,
  });

  /// Resolves [breakpoint] against the width of [constraints].
  ///
  /// With a fixed [LayoutBreakpoint.body] the body keeps that width and the
  /// margin is calculated around it; otherwise the body fills the width left
  /// after removing the margin from both sides.
  factory LayoutConstraints.fromBoxConstraints({
    required BoxConstraints constraints,
    required LayoutBreakpoint breakpoint,
  }) {
    final double width;
    final double margin;
    if (breakpoint.body != null) {
      // static body size.
      width = breakpoint.body!;
      margin = calculateMargin(
        constraints.normalize().maxWidth,
        width,
        breakpoint,
      );
    } else {
      // scaling body size.
      final norm = constraints.normalize();
      margin = calculateMargin(norm.maxWidth, 0, breakpoint);
      width = norm.maxWidth - (margin * 2);
    }
    final spanSize = calculateAxisSize(width, breakpoint);
    return LayoutConstraints(
      body: breakpoint.body,
      margin: margin,
      axes: breakpoint.axes,
      axisSize: spanSize,
      spacing: breakpoint.spacing,
    );
  }

  /// Calculates the margin for each side of the body.
  ///
  /// [width] is the available width and [widthOffset] the body width (0 for a
  /// scaling body). See [LayoutBreakpoint.minMargin] and
  /// [LayoutBreakpoint.maxMargin] for how the margin is chosen.
  static double calculateMargin(
    double width,
    double widthOffset,
    LayoutBreakpoint breakpoint,
  ) {
    assert(
      breakpoint.minMargin < width,
      "Minimum Margin (${breakpoint.minMargin} is larger than available width ($width)",
    );
    if (breakpoint.maxMargin == 0 && breakpoint.minMargin == 0) return 0;
    if (breakpoint.maxMargin == 0 && widthOffset > 0) {
      return (width - widthOffset) / 2;
    }
    if (breakpoint.maxMargin == 0) return breakpoint.minMargin;
    final double range = breakpoint.maxWidth - breakpoint.minWidth;
    // A zero-width or unbounded (infinite) range can't be scaled between; fall back to minMargin.
    if (range <= 0 || !range.isFinite) return breakpoint.minMargin;
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final double percentage = (width - breakpoint.minWidth) / range;
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  /// Calculates the size of a single axis when [width] is divided into
  /// [LayoutBreakpoint.axes] axes separated by [LayoutBreakpoint.spacing].
  static double calculateAxisSize(double width, LayoutBreakpoint breakpoint) {
    final axes = breakpoint.axes;
    final spacing = breakpoint.spacing;
    final totalSpacing = spacing * (axes - 1);
    final totalSpanSize = width - totalSpacing;
    final spanSize = totalSpanSize / axes;
    return spanSize;
  }

  /// The fixed body width, or null when the body scales.
  final double? body;

  /// The number of axes (columns).
  final int axes;

  /// The size of a single axis, excluding spacing.
  final double axisSize;

  /// The margin on each side of the body.
  final double margin;

  /// The spacing between adjacent axes.
  final double spacing;

  /// The total width covered by [axes] adjacent axes, including the spacing
  /// between them.
  double calculateSpan(int axes) {
    final totalAxisSize = axisSize * axes;
    final totalSpacingSize = spacing * (axes - 1);
    return totalAxisSize + totalSpacingSize;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutConstraints &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          axes == other.axes &&
          axisSize == other.axisSize &&
          margin == other.margin &&
          spacing == other.spacing;

  @override
  int get hashCode => Object.hash(body, axes, axisSize, margin, spacing);

  @override
  String toString() {
    return 'LayoutConstraints{'
        'body: $body, '
        'axes: $axes, '
        'axisSize: $axisSize, '
        'margin: $margin, '
        'spacing: $spacing}';
  }
}
