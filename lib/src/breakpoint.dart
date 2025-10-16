import 'package:flutter/widgets.dart';

import 'device_type.dart';
import 'platform_type.dart';
import 'window/window_type.dart';

final class WindowBreakpoint<T extends WindowType> {// TODO move to separate file

  final double minHeight;

  final double maxHeight;

  final double minWidth;

  final double maxWidth;

  final Orientation? orientation;
  
  final DeviceType? device;
  
  final PlatformType? platform;

  final T window;

  const WindowBreakpoint({
    this.minHeight = 0,
    this.maxHeight = double.maxFinite,
    this.minWidth = 0,
    this.maxWidth = double.maxFinite,
    this.orientation,
    this.device,
    this.platform,
    required this.window
  }) : assert(minHeight >= 0),
        assert(maxHeight >= 0),
        assert(minWidth >= 0),
        assert(maxWidth >= 0);

  bool inRange({
    required MediaQueryData mediaQuery,
    required DeviceType device,
    required PlatformType platform
  }) {
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final orientation = mediaQuery.orientation;

    if (minHeight > height || height > maxHeight) return false;
    if (minWidth > width || width > maxWidth) return false;
    if (this.orientation != null && orientation != this.orientation) return false;
    if (this.device != null && device != this.device) return false;
    if (this.platform != null && platform != this.platform) return false;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WindowBreakpoint && runtimeType == other.runtimeType &&
              minHeight == other.minHeight && maxHeight == other.maxHeight &&
              minWidth == other.minWidth && maxWidth == other.maxWidth &&
              orientation == other.orientation && device == other.device &&
              platform == other.platform && window == other.window;

  @override
  int get hashCode =>
      Object.hash(
          minHeight,
          maxHeight,
          minWidth,
          maxWidth,
          orientation,
          device,
          platform,
          window);

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
        'window: $window}';
  }
}

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