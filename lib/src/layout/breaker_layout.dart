import 'package:flutter/widgets.dart';

import '../../breaker.dart';

final class BreakerLayout extends StatelessWidget {
  const BreakerLayout({ // TODO create a BreakerLayout delegate for vertical, horizontal, and grid layouts - replace responsive layout
    super.key,
    required this.breakpoints,
    required this.child
  });

  final List<LayoutBreakpoint> breakpoints;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        breakpoints: breakpoints,
        builder: (context, constraints) {
          return LayoutModel(
            body: constraints.body,
            margin: constraints.margin,
            axes: constraints.axes,
            axisSize: constraints.axisSize,
            spacing: constraints.spacing,
            child: child,
          );
        }
    );
  }
}

enum LayoutAspect {
  body,
  axes,
  axisSize,
  margin,
  spacing;
}

final class LayoutModel extends InheritedModel<LayoutAspect> {
  const LayoutModel({
    super.key,
    this.body,
    required this.axes,
    required this.axisSize,
    required this.margin,
    required this.spacing,
    required super.child
  });

  static LayoutModel of(BuildContext context, [LayoutAspect? aspect]) =>
      InheritedModel.inheritFrom(context, aspect: aspect)!;

  static LayoutModel? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  final double? body;
  final int axes;
  final double axisSize;
  final double margin;
  final double spacing;

  @override
  bool updateShouldNotify(covariant LayoutModel oldWidget) =>
      body != oldWidget.body
          || axes != oldWidget.axes
          || margin != oldWidget.margin
          || spacing != oldWidget.spacing;

  @override
  bool updateShouldNotifyDependent(covariant LayoutModel oldWidget, Set<LayoutAspect> dependencies) {
    for (final aspect in dependencies) {
      switch (aspect) {
        case LayoutAspect.body:
          if (body != oldWidget.body) {
            return true;
          }
          break;
        case LayoutAspect.axes:
          if (axes != oldWidget.axes) {
            return true;
          }
          break;
        case LayoutAspect.axisSize:
          if (axisSize != oldWidget.axisSize) {
            return true;
          }
          break;
        case LayoutAspect.margin:
          if (margin != oldWidget.margin) {
            return true;
          }
          break;
        case LayoutAspect.spacing:
          if (spacing != oldWidget.spacing) {
            return true;
          }
          break;
      }
    }
    return false;
  }
}