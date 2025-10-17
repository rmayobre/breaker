import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';

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
      // static body size.
      width = breakpoint.body!;
      margin = calculateMargin(constraints.normalize().maxWidth, width, breakpoint);
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

  static double calculateMargin(double width, double widthOffset, LayoutBreakpoint breakpoint) {
    if (breakpoint.maxMargin == 0 && breakpoint.minMargin == 0) return 0;
    if (breakpoint.maxMargin == 0  && widthOffset > 0) return (width - widthOffset) / 2;
    if (breakpoint.maxMargin == 0 || breakpoint.maxWidth == 0) return breakpoint.minMargin;
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final double percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  // TODO fix the margin calculations and assertions
  // static double calculateMargin(double width, LayoutBreakpoint breakpoint) {
  //   assert(() {
  //     final body = breakpoint.body;
  //     if (body == null) return true;
  //     if (width < body) throw ArgumentError("Width ($width) is smaller than breakpoint body ($body).");
  //     if (body + (breakpoint.minMargin * 2) > width) {
  //       throw ArgumentError("Breakpoint body ($body) with min margin (${breakpoint.minMargin}) cannot be larger than width.");
  //     }
  //     return true;
  //   }());
  //   if (breakpoint.maxMargin == 0 && breakpoint.minMargin == 0) return 0;
  //   if (breakpoint.maxMargin == 0  && breakpoint.body != null && breakpoint.body! > 0) {
  //     final availableSpace = width - breakpoint.body!;
  //     return (width - breakpoint.body!) / 2;
  //   }
  //   if (breakpoint.maxMargin == 0 || breakpoint.maxWidth == 0) return breakpoint.minMargin;
  //   final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
  //   final double percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
  //   return (marginOffset * percentage) + breakpoint.minMargin;
  // }

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