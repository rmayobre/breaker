import 'package:flutter/widgets.dart';

import 'layout_constraints.dart';
import 'span_calculator.dart';

abstract interface class Cell {

  factory Cell({
    required SpanCalculator span,
    required Widget child,
  }) => _StatelessCell(span: span, child: child);

  Widget build(BuildContext context, LayoutConstraints constraints);
}

final class _StatelessCell implements Cell {
  const _StatelessCell({
    required this.span,
    required this.child
  });

  final SpanCalculator span;

  final Widget child;

  @override
  Widget build(BuildContext context, LayoutConstraints constraints) {
    final spanSize = span(constraints);
    final spanSizeTotal = constraints.spanSize * spanSize;
    final spacingTotal = constraints.spacing * (spanSize - 1);
    return SizedBox(
      width: spanSizeTotal + spacingTotal,
      child: child,
    );
  }
}