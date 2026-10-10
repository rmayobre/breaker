import 'package:flutter/widgets.dart';

import '../breakpoint_resolver.dart';
import '../layout_breakpoint.dart';
import 'layout_constraints.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, LayoutConstraints constraints);

final class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.breakpoints,
    this.fallback,
    required this.builder,
  }) : assert(
         breakpoints.length > 0,
         'ResponsiveLayoutBuilder requires at least one LayoutBreakpoint.',
       );

  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = resolveBreakpoint<LayoutBreakpoint>(
          breakpoints: breakpoints,
          matches: (breakpoint) => breakpoint.inRange(constraints),
          fallback: fallback,
        );
        final layoutConstraints = LayoutConstraints.fromBoxConstraints(
          constraints: constraints,
          breakpoint: breakpoint,
        );
        return builder(context, layoutConstraints);
      },
    );
  }
}
