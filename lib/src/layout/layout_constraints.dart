import 'package:flutter/widgets.dart';

import '../breakpoint.dart';

final class LayoutConstraints {

  const LayoutConstraints({
    this.body,
    required this.axes,
    required this.axisSize,
    required this.margin,
    required this.spacing,
  });

  factory LayoutConstraints.fromBoxConstraints({
    required BoxConstraints constraints,
    required LayoutBreakpoint breakpoint,
  }) {
    final double width;
    final double margin;
    if (breakpoint.body != null) {
      width = breakpoint.body!;
      margin = calculateMargin(constraints.normalize().maxWidth, width, breakpoint);
    } else {
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

  static double calculateMargin(double width, double widthOffset, LayoutBreakpoint breakpoint) {
    if (breakpoint.maxMargin == 0 && breakpoint.minMargin == 0) return 0;
    if (breakpoint.maxMargin == 0  && widthOffset > 0) return (width - widthOffset) / 2;
    if (breakpoint.maxMargin == 0 || breakpoint.maxWidth == 0) return breakpoint.minMargin;
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final double percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  static double calculateAxisSize(double width, LayoutBreakpoint breakpoint) {
    final axes = breakpoint.axes;
    final spacing = breakpoint.spacing;
    final totalSpacing = spacing * (axes - 1);
    final totalSpanSize = width - totalSpacing;
    final spanSize = totalSpanSize / axes;
    return spanSize;
  }

  final double? body;
  final int axes;
  final double axisSize;
  final double margin;
  final double spacing;

  double calculateSpan(int axes) {
    final totalAxisSize = axisSize * axes;
    final totalSpacingSize = spacing * (axes - 1);
    return totalAxisSize + totalSpacingSize;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LayoutConstraints && runtimeType == other.runtimeType &&
              body == other.body && axes == other.axes &&
              axisSize == other.axisSize && margin == other.margin &&
              spacing == other.spacing;

  @override
  int get hashCode =>
      Object.hash(
          body,
          axes,
          axisSize,
          margin,
          spacing);

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