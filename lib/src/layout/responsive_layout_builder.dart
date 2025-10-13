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
    if (breakpoint.maxMargin < breakpoint.minMargin) {

    }
    final double marginOffset = breakpoint.maxMargin - breakpoint.minMargin;
    final double percentage = ((width - breakpoint.minWidth)) / (breakpoint.maxWidth - breakpoint.minWidth);
    return (marginOffset * percentage) + breakpoint.minMargin;
  }

  // static double _calculateSpanSize(double width, double margin, int span, double spacing) {
  //   final totalMargin = margin * 2;
  //   final totalSpacing = spacing * (span - 1);
  //   final totalSpanSize = width - totalMargin - totalSpacing;
  //   return totalSpanSize / span;
  // }

  // TODO rename to calculateWidgetSize
  static double _calculateSpanSize(double width, int span, double spacing) {
    final totalSpacing = spacing * (span - 1);
    final totalSpanSize = width - totalSpacing;
    final spanSize = totalSpanSize / span;
    print('width: $width, span: $span, spacing: $spacing, totalSpacing: $totalSpacing, totalSpanSize: $totalSpanSize, spanSize: $spanSize');
    return spanSize;
    // return totalSpanSize / span;
  }

  final List<LayoutBreakpoint> breakpoints;

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final breakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.inRange(constraints));
      print(breakpoint);
      /*
      TODO - calculate margin with body size.
      TODO - calculate spanSize with body size.
       */
      final double width;
      final double margin;
      if (breakpoint.body != null) {
        width = breakpoint.body!;
        margin = _calculateMargin(constraints.normalize().maxWidth, breakpoint);
      } else {
        final norm = constraints.normalize();
        margin = _calculateMargin(norm.maxWidth, breakpoint);
        width = norm.maxWidth - (margin * 2);
      }
      // final double width = constraints.normalize().maxWidth;
      // final margin = _calculateMargin(width, breakpoint);
      final spanSize = _calculateSpanSize(width, breakpoint.span, breakpoint.spacing);
      print('width: $width, margin: $margin, spanSize: $spanSize');
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