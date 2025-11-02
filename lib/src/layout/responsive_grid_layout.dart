import 'package:flutter/widgets.dart';

import '../layout_breakpoint.dart';
import 'layout_constraints.dart';
import 'responsive_layout_builder.dart';
import 'responsive_layout_overlay.dart';
import 'axis_calculator.dart';

///
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
///           columns: (constraints) => (constraints.span / 2).toInt(), // Each item covers two columns.
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
    required this.itemBuilder,
  });

  final bool debugOverlay;
  
  final double? axisExtent;

  final AxisCalculator axisCount;

  final List<LayoutBreakpoint> breakpoints;

  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        breakpoints: breakpoints,
        builder: (context, constraints) {
          if (debugOverlay) {
            return ResponsiveLayoutOverlay(
                constraints: constraints,
                child: _buildGrid(constraints)
            );
          }
          return _buildGrid(constraints);
        }
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
          mainAxisExtent: axisExtent
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}