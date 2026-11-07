import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';
import 'cell.dart';
import 'layout_constraints.dart';
import 'responsive_layout_builder.dart';
import 'responsive_layout_overlay.dart';

/// Lays [cells] out in a horizontal [Row] (vertical columns of the grid), sized
/// and spaced according to the active [LayoutBreakpoint].
///
/// Each [Cell] spans a number of axes; the layout inserts the breakpoint's
/// spacing between cells and applies its margins. Breakpoints are evaluated in
/// order and the first match wins. If none match, [fallback] is used, or the
/// first breakpoint when [fallback] is null.
final class ResponsiveVerticalLayout extends StatelessWidget {
  const ResponsiveVerticalLayout({
    super.key,
    this.panes,
    this.debugOverlay = false,
    required this.breakpoints,
    this.fallback,
    required this.cells,
  }) : assert(
         breakpoints.length > 0,
         'ResponsiveVerticalLayout requires at least one LayoutBreakpoint.',
       );

  /// Currently unused; reserved for pane-aware layouts.
  final int? panes;

  /// Whether to draw a [ResponsiveLayoutOverlay] behind the cells.
  final bool debugOverlay;

  /// The candidate breakpoints, in priority order. Must not be empty.
  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  /// The cells to lay out, in order.
  final List<Cell> cells;

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
    breakpoints: breakpoints,
    fallback: fallback,
    builder: _build,
  );

  Widget _build(BuildContext context, LayoutConstraints constraints) {
    if (debugOverlay) {
      return ResponsiveLayoutOverlay(
        constraints: constraints,
        child: _buildChildren(context, constraints),
      );
    }
    return _buildChildren(context, constraints);
  }

  Widget _buildChildren(BuildContext context, LayoutConstraints constraints) {
    final rowChildren = <Widget>[];
    for (int i = 0; i < cells.length; i++) {
      rowChildren.add(cells[i].build(context, constraints));
      if (i < cells.length - 1) {
        // ignore the last index.
        rowChildren.add(SizedBox(width: constraints.spacing));
      }
    }
    if (constraints.body != null) {
      return Container(
        width: constraints.body!,
        margin: EdgeInsets.symmetric(horizontal: constraints.margin),
        child: Row(mainAxisSize: MainAxisSize.max, children: rowChildren),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: constraints.margin),
      child: Row(children: rowChildren),
    );
  }
}
