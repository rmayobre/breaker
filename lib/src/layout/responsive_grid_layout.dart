import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';
import 'layout_constraints.dart';
import 'responsive_layout_builder.dart';
import 'responsive_layout_overlay.dart';
import 'axis_calculator.dart';

/// A [GridView] whose column count, spacing and margins follow the active
/// [LayoutBreakpoint].
///
/// Breakpoints are evaluated in order and the first match wins. If none match,
/// [fallback] is used, or the first breakpoint when [fallback] is null.
///
/// ## Example Build Function
/// ```dart
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
///         title: Text(widget.title),
///       ),
///       body: ResponsiveGridLayout(
///           axisCount: (constraints) => constraints.axes ~/ 2, // Each item covers two axes.
///           breakpoints: materialLayoutBreakpoints,
///           itemBuilder: (context, index) => Card(child: Center(child: Text('Item $index')))
///       ),
///     );
///   }
/// ```
final class ResponsiveGridLayout extends StatelessWidget {
  const ResponsiveGridLayout({
    super.key,
    this.debugOverlay = false,
    this.axisExtent,
    required this.axisCount,
    required this.breakpoints,
    this.fallback,
    required this.itemBuilder,
  }) : assert(
         breakpoints.length > 0,
         'ResponsiveGridLayout requires at least one LayoutBreakpoint.',
       );

  /// Whether to draw a [ResponsiveLayoutOverlay] behind the grid.
  final bool debugOverlay;

  /// The fixed extent of each item along the scrolling axis, or null to make
  /// items square.
  final double? axisExtent;

  /// Calculates the number of grid columns from the resolved constraints.
  final AxisCalculator axisCount;

  /// The candidate breakpoints, in priority order. Must not be empty.
  final List<LayoutBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current constraints.
  /// If null, the first entry in [breakpoints] is used instead.
  final LayoutBreakpoint? fallback;

  /// Builds the item at an index. Returning null ends the grid.
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      breakpoints: breakpoints,
      fallback: fallback,
      builder: (context, constraints) {
        if (debugOverlay) {
          return ResponsiveLayoutOverlay(
            constraints: constraints,
            child: _buildGrid(constraints),
          );
        }
        return _buildGrid(constraints);
      },
    );
  }

  Widget _buildGrid(LayoutConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: constraints.margin),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axisCount(constraints),
          crossAxisSpacing: constraints.spacing,
          mainAxisSpacing: constraints.spacing,
          mainAxisExtent: axisExtent,
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
