import 'package:flutter/widgets.dart';

import 'device_type.dart';
import 'platform_type.dart';
import 'window/navigation_type.dart';

final class WindowBreakpoint {

  final double minHeight;

  final double maxHeight;

  final double minWidth;

  final double maxWidth;

  final Orientation? orientation;

  final DeviceType? device;

  final PlatformType? platform;

  final NavigationType? navigation;

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
    required this.panes
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
              platform == other.platform && navigation == other.navigation &&
              panes == other.panes;

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
          navigation,
          panes);

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