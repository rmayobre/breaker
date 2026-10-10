import 'package:flutter/widgets.dart';

import 'layout_model.dart';
import 'responsive_layout_builder.dart';
import '../layout_breakpoint.dart';

final class BreakerLayout extends StatelessWidget {
  const BreakerLayout({
    // TODO create a BreakerLayout delegate for vertical, horizontal, and grid layouts - replace responsive layout
    super.key,
    required this.breakpoints,
    this.fallback,
    required this.child,
  }) : assert(
         breakpoints.length > 0,
         'BreakerLayout requires at least one LayoutBreakpoint.',
       );

  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      breakpoints: breakpoints,
      fallback: fallback,
      builder: (context, constraints) {
        return LayoutModel(
          body: constraints.body,
          margin: constraints.margin,
          axes: constraints.axes,
          axisSize: constraints.axisSize,
          spacing: constraints.spacing,
          child: child,
        );
      },
    );
  }
}
