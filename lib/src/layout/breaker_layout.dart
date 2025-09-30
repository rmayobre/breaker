import 'package:flutter/widgets.dart';

import '../../breaker.dart';

final class BreakerLayout extends StatelessWidget {
  const BreakerLayout({
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
        builder: (context, constraints) =>
            LayoutModel(
              body: constraints.body,
              margin: constraints.margin,
              span: constraints.span,
              spanSize: constraints.spanSize,
              spacing: constraints.spacing,
              child: child,
            )
    );
  }
}

enum LayoutAspect {
  body,
  span,
  spanSize,
  margin,
  spacing;
}

final class LayoutModel extends InheritedModel<LayoutAspect> {
  const LayoutModel({
    super.key,
    this.body,
    required this.span,
    required this.spanSize,
    required this.margin,
    required this.spacing,
    required super.child
  });

  static LayoutModel of(BuildContext context, [LayoutAspect? aspect]) =>
      InheritedModel.inheritFrom(context, aspect: aspect)!;

  static LayoutModel? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  final int? body;

  final int span;

  final double spanSize;

  final double margin;

  final double spacing;

  @override
  bool updateShouldNotify(covariant LayoutModel oldWidget) =>
      body != oldWidget.body
          || span != oldWidget.span
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
        case LayoutAspect.span:
          if (span != oldWidget.span) {
            return true;
          }
          break;
        case LayoutAspect.spanSize:
          if (spanSize != oldWidget.spanSize) {
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