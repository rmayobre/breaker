import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';
import 'cell.dart';
import 'layout_constraints.dart';
import 'responsive_layout_builder.dart';
import 'responsive_layout_overlay.dart';

final class ResponsiveVerticalLayout extends StatelessWidget {
  const ResponsiveVerticalLayout({
    super.key,
    this.panes,
    this.debugOverlay = false,
    required this.breakpoints,
    required this.cells
  });
  
  final int? panes;

  final bool debugOverlay;

  final List<LayoutBreakpoint> breakpoints;

  final List<Cell> cells;

  @override
  Widget build(BuildContext context) =>
      ResponsiveLayoutBuilder(breakpoints: breakpoints, builder: _build);

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
      if (i < cells.length - 1) rowChildren.add(SizedBox(width: constraints.spacing)); // ignore the last index.
    }
    if (constraints.body != null) {
      return Container(
        width: constraints.body!,
        margin: EdgeInsets.symmetric(horizontal: constraints.margin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: rowChildren,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: constraints.margin),
      child: Row(
        children: rowChildren
      ),
    );
  }
}