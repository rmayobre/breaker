import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';
import 'axis_calculator.dart';

abstract interface class Cell {

  factory Cell({
    required AxisCalculator span,
    required Widget child,
  }) => _Cell(axes: span, child: child);

  Widget build(BuildContext context, LayoutConstraints constraints);
}

final class _Cell implements Cell {
  const _Cell({
    required this.axes,
    required this.child
  });

  final AxisCalculator axes;

  final Widget child;

  @override
  Widget build(BuildContext context, LayoutConstraints constraints) {
    final axisCount = axes(constraints);
    return SizedBox(
      width: constraints.calculateSpan(axisCount),
      child: child,
    );
  }
}