import 'package:flutter/widgets.dart';

/// The individually observable values of a [LayoutModel].
enum LayoutAspect { body, axes, axisSize, margin, spacing }

/// An [InheritedModel] exposing the resolved layout values.
///
/// Dependents subscribe to a single [LayoutAspect] and are rebuilt only when
/// that aspect changes. Provided by [BreakerLayout]; most code should use the
/// [Breaker] accessors rather than this class directly.
final class LayoutModel extends InheritedModel<LayoutAspect> {
  const LayoutModel({
    super.key,
    this.body,
    required this.axes,
    required this.axisSize,
    required this.margin,
    required this.spacing,
    required super.child,
  });

  /// Returns the nearest [LayoutModel], depending on [aspect] if given.
  ///
  /// Throws if there is no [BreakerLayout] ancestor.
  static LayoutModel of(BuildContext context, [LayoutAspect? aspect]) =>
      InheritedModel.inheritFrom(context, aspect: aspect)!;

  /// Like [of] but returns null instead of throwing when there is no
  /// [BreakerLayout] ancestor. Depends on every aspect of the model.
  static LayoutModel? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  /// The fixed body width, or null when the body scales.
  final double? body;

  /// The number of axes (columns).
  final int axes;

  /// The size of a single axis, excluding spacing.
  final double axisSize;

  /// The margin on each side of the body.
  final double margin;

  /// The spacing between adjacent axes.
  final double spacing;

  @override
  bool updateShouldNotify(covariant LayoutModel oldWidget) =>
      body != oldWidget.body ||
      axes != oldWidget.axes ||
      axisSize != oldWidget.axisSize ||
      margin != oldWidget.margin ||
      spacing != oldWidget.spacing;

  @override
  bool updateShouldNotifyDependent(
    covariant LayoutModel oldWidget,
    Set<LayoutAspect> dependencies,
  ) {
    for (final aspect in dependencies) {
      switch (aspect) {
        case LayoutAspect.body:
          if (body != oldWidget.body) return true;
          break;
        case LayoutAspect.axes:
          if (axes != oldWidget.axes) return true;
          break;
        case LayoutAspect.axisSize:
          if (axisSize != oldWidget.axisSize) return true;
          break;
        case LayoutAspect.margin:
          if (margin != oldWidget.margin) return true;
          break;
        case LayoutAspect.spacing:
          if (spacing != oldWidget.spacing) return true;
          break;
      }
    }
    return false;
  }
}
