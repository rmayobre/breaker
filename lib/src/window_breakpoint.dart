import 'package:flutter/widgets.dart';

import 'device_type.dart';
import 'platform_type.dart';
import 'window/navigation_type.dart';

/// Describes the window configuration for a range of window sizes.
///
/// A breakpoint applies when the window size is within
/// `[minWidth, maxWidth]` and `[minHeight, maxHeight]` (both inclusive) and the
/// optional [orientation], [device] and [platform] filters match; filters left
/// null match anything. Breakpoints are evaluated in list order and the first
/// match wins, so adjacent breakpoints may share a boundary value.
///
/// ```dart
/// const WindowBreakpoint(
///   minWidth: 600,
///   navigation: NavigationType.sideBar,
///   panes: 2,
/// )
/// ```
final class WindowBreakpoint {
  /// The smallest window height, inclusive, at which this breakpoint applies.
  final double minHeight;

  /// The largest window height, inclusive, at which this breakpoint applies.
  final double maxHeight;

  /// The smallest window width, inclusive, at which this breakpoint applies.
  final double minWidth;

  /// The largest window width, inclusive, at which this breakpoint applies.
  final double maxWidth;

  /// Restricts this breakpoint to one [Orientation]; null matches both.
  final Orientation? orientation;

  /// Restricts this breakpoint to one [DeviceType]; null matches any.
  final DeviceType? device;

  /// Restricts this breakpoint to one [PlatformType]; null matches any.
  final PlatformType? platform;

  /// The navigation style to use while this breakpoint is active, if any.
  final NavigationType? navigation;

  /// The number of panes supported while this breakpoint is active.
  final int panes;

  const WindowBreakpoint({
    this.minHeight = 0,
    this.maxHeight = double.maxFinite,
    this.minWidth = 0,
    this.maxWidth = double.maxFinite,
    this.orientation,
    this.device,
    this.platform,
    this.navigation,
    required this.panes,
  }) : assert(minHeight >= 0),
       assert(maxHeight >= 0),
       assert(minWidth >= 0),
       assert(maxWidth >= 0);

  /// Whether this breakpoint applies to the window described by [mediaQuery]
  /// running on [device] and [platform].
  bool inRange({
    required MediaQueryData mediaQuery,
    required DeviceType device,
    required PlatformType platform,
  }) {
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final orientation = mediaQuery.orientation;

    if (minHeight > height || height > maxHeight) return false;
    if (minWidth > width || width > maxWidth) return false;
    if (this.orientation != null && orientation != this.orientation) {
      return false;
    }
    if (this.device != null && device != this.device) return false;
    if (this.platform != null && platform != this.platform) return false;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowBreakpoint &&
          runtimeType == other.runtimeType &&
          minHeight == other.minHeight &&
          maxHeight == other.maxHeight &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          orientation == other.orientation &&
          device == other.device &&
          platform == other.platform &&
          navigation == other.navigation &&
          panes == other.panes;

  @override
  int get hashCode => Object.hash(
    minHeight,
    maxHeight,
    minWidth,
    maxWidth,
    orientation,
    device,
    platform,
    navigation,
    panes,
  );

  @override
  String toString() {
    return 'WindowBreakpoint{'
        'minHeight: $minHeight, '
        'maxHeight: $maxHeight, '
        'minWidth: $minWidth, '
        'maxWidth: $maxWidth, '
        'orientation: $orientation, '
        'device: $device, '
        'platform: $platform, '
        'navigation: $navigation, '
        'panes: $panes}';
  }
}
