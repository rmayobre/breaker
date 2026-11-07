import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';
import 'axis_calculator.dart';

/// A child of a responsive layout that spans a number of axes (columns).
///
/// Use the [Cell.new] factory to create one; its width is the size of the
/// calculated span, including the spacing between the spanned axes.
abstract interface class Cell {
  /// Creates a cell whose width covers [span] axes of the current layout,
  /// containing [child].
  factory Cell({required AxisCalculator span, required Widget child}) =>
      _Cell(axes: span, child: child);

  /// Builds the cell's widget for the given resolved [constraints].
  Widget build(BuildContext context, LayoutConstraints constraints);
}

final class _Cell implements Cell {
  const _Cell({required this.axes, required this.child});

  final AxisCalculator axes;

  final Widget child;

  @override
  Widget build(BuildContext context, LayoutConstraints constraints) {
    final axisCount = axes(constraints);
    return SizedBox(width: constraints.calculateSpan(axisCount), child: child);
  }
}
