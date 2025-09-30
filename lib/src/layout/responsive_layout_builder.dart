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

  static double _calculateMargin(double width, LayoutBreakpoint breakpoint) {
    if (breakpoint.maxMargin == 0 || breakpoint.maxWidth == 0) return breakpoint.minMargin;
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  static double _calculateSpanSize(double width, double margin, int span, double spacing) {
    final totalMargin = margin * 2;
    final totalSpacing = spacing * (span - 1);
    final totalSpanSize = width - totalMargin - totalSpacing;
    return totalSpanSize / span;
  }

  final List<LayoutBreakpoint> breakpoints;

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final breakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.inRange(constraints));
      final width = constraints.normalize().maxWidth;
      final margin = _calculateMargin(width, breakpoint);
      final spanSize = _calculateSpanSize(width, margin, breakpoint.span, breakpoint.spacing);
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