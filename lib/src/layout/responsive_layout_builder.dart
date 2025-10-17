import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';
import 'layout_constraints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context, LayoutConstraints constraints);

final class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.breakpoints,
    required this.builder
  });

  final List<LayoutBreakpoint> breakpoints;

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final breakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.inRange(constraints));
      final layoutConstraints = LayoutConstraints.fromBoxConstraints(
          constraints: constraints,
          breakpoint: breakpoint
      );
      return builder(context, layoutConstraints);
    });
  }
}