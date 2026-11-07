import 'package:flutter/widgets.dart';

import 'layout_model.dart';
import 'responsive_layout_builder.dart';
import '../layout_breakpoint.dart';

/// Resolves the active [LayoutBreakpoint] from the available constraints and
/// exposes the result to descendants through a [LayoutModel].
///
/// Place it below a [BreakerWindow] (or anywhere with bounded width). Descendants
/// read the values with the [Breaker] accessors (e.g. `Breaker.axes(context)`).
///
/// Breakpoints are evaluated in order and the first match wins. If none match,
/// [fallback] is used, or the first breakpoint when [fallback] is null.
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

  /// The candidate breakpoints, in priority order. Must not be empty.
  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  /// The widget subtree that can read the resolved layout values.
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
