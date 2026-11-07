import 'package:flutter/widgets.dart';

import '../breakpoint_resolver.dart';
import '../layout_breakpoint.dart';
import 'layout_constraints.dart';

/// Builds a widget from the resolved [LayoutConstraints].
typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, LayoutConstraints constraints);

/// A [LayoutBuilder] that resolves the active [LayoutBreakpoint] and passes the
/// resulting [LayoutConstraints] to [builder].
///
/// Use it to build custom layouts; [ResponsiveVerticalLayout] and
/// [ResponsiveGridLayout] are built on top of it. Breakpoints are evaluated in
/// order and the first match wins. If none match, [fallback] is used, or the
/// first breakpoint when [fallback] is null.
///
/// ```dart
/// ResponsiveLayoutBuilder(
///   breakpoints: materialLayoutBreakpoints,
///   builder: (context, constraints) => Text('${constraints.axes} columns'),
/// )
/// ```
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

  /// The candidate breakpoints, in priority order. Must not be empty.
  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  /// Builds the child from the resolved layout constraints.
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
