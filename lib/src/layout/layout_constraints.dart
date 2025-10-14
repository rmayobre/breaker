import 'package:flutter/widgets.dart';

import '../breakpoint.dart';

final class LayoutConstraints {

  const LayoutConstraints({
    this.body,
    required this.span,
    required this.spanSize,
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
    final spanSize = calculateSpanSize(width, breakpoint);
    return LayoutConstraints(
      body: breakpoint.body,
      margin: margin,
      span: breakpoint.span,
      spanSize: spanSize,
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

  // TODO rename to calculateAxisSize?
  static double calculateSpanSize(double width, LayoutBreakpoint breakpoint) {
    final span = breakpoint.span;
    final spacing = breakpoint.spacing;
    final totalSpacing = spacing * (span - 1);
    final totalSpanSize = width - totalSpacing;
    final spanSize = totalSpanSize / span;
    return spanSize;
  }

  final double? body;
  final int span; // TODO spans?
  final double spanSize; // TODO axisSize?
  final double margin;
  final double spacing;

  double calculateSpan(int span) { // TODO rename?
    final spanSizeTotal = spanSize * span;
    final spacingTotal = spacing * (span - 1);
    return spanSizeTotal + spacingTotal;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LayoutConstraints && runtimeType == other.runtimeType &&
              body == other.body && span == other.span &&
              spanSize == other.spanSize && margin == other.margin &&
              spacing == other.spacing;

  @override
  int get hashCode =>
      Object.hash(
          body,
          span,
          spanSize,
          margin,
          spacing);

  @override
  String toString() {
    return 'LayoutConstraints{'
        'body: $body, '
        'span: $span, '
        'spanSize: $spanSize, '
        'margin: $margin, '
        'spacing: $spacing}';
  }
}