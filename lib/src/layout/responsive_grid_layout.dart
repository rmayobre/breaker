import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';
import 'responsive_layout_builder.dart';
import 'responsive_layout_overlay.dart';
import 'span_calculator.dart';
import '../breakpoint.dart';

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
    this.isOverlayEnabled = false,
    required this.columns,
    required this.breakpoints,
    required this.itemBuilder,
  });

  final bool isOverlayEnabled;

  final SpanCalculator columns;

  final List<LayoutBreakpoint> breakpoints;

  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        breakpoints: breakpoints,
        builder: (context, constraints) {
          if (isOverlayEnabled) {
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
          crossAxisCount: columns(constraints),
          crossAxisSpacing: constraints.spacing,
          mainAxisSpacing: constraints.spacing,
          // childAspectRatio: 0.7,
          // mainAxisExtent: 950 // TODO handle height/aspect-ratio
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}