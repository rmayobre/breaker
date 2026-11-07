import 'package:flutter/widgets.dart';

/// Describes a column grid for a range of available sizes.
///
/// A breakpoint applies when the available width and height fall within
/// `[minWidth, maxWidth]` and `[minHeight, maxHeight]` (both ends inclusive;
/// see [inRange]). Breakpoints are evaluated in list order and the first match
/// wins, so adjacent breakpoints may share a boundary value.
///
/// ```dart
/// const LayoutBreakpoint(
///   minWidth: 905,
///   body: 840,
///   minMargin: 32,
///   axes: 12,
///   spacing: 12,
/// )
/// ```
final class LayoutBreakpoint {
  /// The smallest available height, inclusive, at which this breakpoint applies.
  final double minHeight;

  /// The largest available height, inclusive, at which this breakpoint applies.
  final double maxHeight;

  /// The smallest available width, inclusive, at which this breakpoint applies.
  final double minWidth;

  /// The largest available width, inclusive, at which this breakpoint applies.
  final double maxWidth;

  /// A fixed body width, or null for a body that scales with the available
  /// width.
  ///
  /// When set, the body is centered: if [minMargin] is non-zero and [maxMargin]
  /// is 0, the margin is the space left over on either side of the body.
  final double? body;

  /// The number of axes (columns) in the grid. Must be at least 1.
  final int axes;

  /// The minimum margin on each side of the body.
  ///
  /// If both margins are 0 there is no margin. If [maxMargin] is 0 and there is
  /// no fixed [body], this is the margin used.
  final double minMargin;

  /// The maximum margin on each side of the body.
  ///
  /// When non-zero, the margin scales linearly from [minMargin] at [minWidth]
  /// to [maxMargin] at [maxWidth]. When 0, the margin is not scaled. A scaling
  /// margin requires a finite [maxWidth]; otherwise [minMargin] is used.
  final double maxMargin;

  /// The spacing between adjacent axes.
  final double spacing;

  const LayoutBreakpoint({
    this.minHeight = 0,
    this.maxHeight = double.infinity,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.body,
    this.minMargin = 0,
    this.maxMargin = 0,
    required this.axes,
    required this.spacing,
  }) : assert(minHeight >= 0),
       assert(maxHeight >= 0),
       assert(minWidth >= 0),
       assert(maxWidth >= 0),
       assert(body == null || body >= 0),
       assert(minMargin >= 0),
       assert(maxMargin >= 0),
       assert(
         axes >= 1,
         'axes must be at least 1; an axes of 0 divides by zero when calculating axis size.',
       ),
       assert(spacing >= 0);

  /// Whether [constraints] fall within this breakpoint's size range.
  ///
  /// The maximum width and height of the (normalized) [constraints] are
  /// compared against the breakpoint's bounds, inclusively.
  bool inRange(BoxConstraints constraints) {
    final height = constraints.normalize().maxHeight;
    final width = constraints.normalize().maxWidth;

    if (minHeight > height || height > maxHeight) return false;
    if (minWidth > width || width > maxWidth) return false;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutBreakpoint &&
          runtimeType == other.runtimeType &&
          minHeight == other.minHeight &&
          maxHeight == other.maxHeight &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          body == other.body &&
          axes == other.axes &&
          minMargin == other.minMargin &&
          maxMargin == other.maxMargin &&
          spacing == other.spacing;

  @override
  int get hashCode => Object.hash(
    minHeight,
    maxHeight,
    minWidth,
    maxWidth,
    body,
    axes,
    minMargin,
    maxMargin,
    spacing,
  );

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
