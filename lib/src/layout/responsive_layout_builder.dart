import 'package:flutter/widgets.dart';

import '../breakpoint.dart';
import 'layout_constraints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context, LayoutConstraints constraints);

final class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.breakpoints,
    required this.builder
  });

  static double _calculateMargin(double width, double widthOffset, LayoutBreakpoint breakpoint) {
    if (breakpoint.maxMargin == 0 && breakpoint.minMargin == 0) return 0;
    if (breakpoint.maxMargin == 0  && widthOffset > 0) return (width - widthOffset) / 2;
    if (breakpoint.maxMargin == 0 || breakpoint.maxWidth == 0) return breakpoint.minMargin;
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final double percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  // TODO rename to calculateAxisSize
  static double _calculateSpanSize(double width, int span, double spacing) {
    final totalSpacing = spacing * (span - 1);
    final totalSpanSize = width - totalSpacing;
    final spanSize = totalSpanSize / span;
    return spanSize;
  }

  final List<LayoutBreakpoint> breakpoints;

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final breakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.inRange(constraints));
      final double width;
      final double margin;
      if (breakpoint.body != null) {
        width = breakpoint.body!;
        margin = _calculateMargin(constraints.normalize().maxWidth, width, breakpoint);
      } else {
        final norm = constraints.normalize();
        margin = _calculateMargin(norm.maxWidth, 0, breakpoint);
        width = norm.maxWidth - (margin * 2);
      }
      final spanSize = _calculateSpanSize(width, breakpoint.span, breakpoint.spacing);
      final layoutConstrains = LayoutConstraints(
        body: breakpoint.body,
        margin: margin,
        span: breakpoint.span,
        spanSize: spanSize,
        spacing: breakpoint.spacing,
      );
      return builder(context, layoutConstrains);
    });
  }
}