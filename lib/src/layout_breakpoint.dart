import 'package:flutter/widgets.dart';

final class LayoutBreakpoint { // TODO move to separate file

  final double minHeight;

  final double maxHeight;

  final double minWidth;

  final double maxWidth;

  final double? body;

  final int axes;

  final double minMargin;

  final double maxMargin;

  final double spacing;

  const LayoutBreakpoint({
    this.minHeight = 0,
    this.maxHeight = double.maxFinite,
    this.minWidth = 0,
    this.maxWidth = double.maxFinite,
    this.body,
    this.minMargin = 0,
    this.maxMargin = 0,
    required this.axes,
    required this.spacing
  }) : assert(minHeight >= 0),
        assert(maxHeight >= 0),
        assert(minWidth >= 0),
        assert(maxWidth >= 0),
        assert(body == null || body >= 0),
        assert(minMargin >= 0),
        assert(maxMargin >= 0),
        assert(axes >= 0),
        assert(spacing >= 0);

  bool inRange(BoxConstraints constraints) {
    final height = constraints.normalize().maxHeight;
    final width = constraints.normalize().maxWidth;

    // assert(() {
    //   final body = this.body;
    //   if (body == null) return true;
    //   if (body + (minMargin * 2) > minWidth) throw ArgumentError("");
    //   return true;
    // }());
    // assert(body == null || body + (margin * 2))

    if (minHeight > height || height > maxHeight) return false;
    if (minWidth > width || width > maxWidth) return false;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LayoutBreakpoint && runtimeType == other.runtimeType &&
              minHeight == other.minHeight && maxHeight == other.maxHeight &&
              minWidth == other.minWidth && maxWidth == other.maxWidth &&
              body == other.body && axes == other.axes &&
              minMargin == other.minMargin && maxMargin == other.maxMargin &&
              spacing == other.spacing;

  @override
  int get hashCode =>
      Object.hash(
          minHeight,
          maxHeight,
          minWidth,
          maxWidth,
          body,
          axes,
          minMargin,
          maxMargin,
          spacing);

  @override
  String toString() {
    return 'LayoutBreakpoint{'
        'minHeight: $minHeight, '
        'maxHeight: $maxHeight, '
        'minWidth: $minWidth, '
        'maxWidth: $maxWidth, '
        'body: $body, '
        'axes: $axes, '
        'minMargin: $minMargin, '
        'maxMargin: $maxMargin, '
        'spacing: $spacing}';
  }
}