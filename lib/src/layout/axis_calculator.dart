import 'layout_constraints.dart';

/// Computes a number of axes (columns) from the resolved [LayoutConstraints],
/// e.g. `(constraints) => constraints.axes ~/ 2` for half the available axes.
typedef AxisCalculator = int Function(LayoutConstraints constraints);
