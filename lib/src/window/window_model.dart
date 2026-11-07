import 'package:flutter/widgets.dart';

import '../device_type.dart';
import '../platform_type.dart';
import 'navigation_type.dart';

/// The individually observable values of a [WindowModel].
enum WindowAspect { device, platform, orientation, navigation, panes }

/// An [InheritedModel] exposing the resolved window values.
///
/// Dependents subscribe to a single [WindowAspect] and are rebuilt only when
/// that aspect changes. Provided by [BreakerWindow]; most code should use the
/// [Breaker] accessors rather than this class directly.
final class WindowModel extends InheritedModel<WindowAspect> {
  const WindowModel({
    super.key,
    required this.device,
    required this.platform,
    required this.orientation,
    required this.navigation,
    required this.panes,
    required super.child,
  });

  /// Returns the nearest [WindowModel], depending on [aspect] if given.
  ///
  /// Throws if there is no [BreakerWindow] ancestor.
  static WindowModel of(BuildContext context, [WindowAspect? aspect]) =>
      InheritedModel.inheritFrom(context, aspect: aspect)!;
  static DeviceType? deviceOf(BuildContext context) =>
      of(context, WindowAspect.device).device;
  static PlatformType? platformOf(BuildContext context) =>
      of(context, WindowAspect.platform).platform;
  static Orientation? orientationOf(BuildContext context) =>
      of(context, WindowAspect.orientation).orientation;
  static NavigationType? navigationOf(BuildContext context) =>
      of(context, WindowAspect.navigation).navigation;
  static int panesOf(BuildContext context) =>
      of(context, WindowAspect.panes).panes;

  /// The [DeviceType] of the running device.
  final DeviceType? device;
  /// The [PlatformType] of the running platform.
  final PlatformType? platform;
  /// The current window [Orientation].
  final Orientation? orientation;
  /// The navigation style of the active breakpoint, if it specifies one.
  final NavigationType? navigation;
  /// The number of panes of the active breakpoint.
  final int panes;

  @override
  bool updateShouldNotify(covariant WindowModel oldWidget) =>
      panes != oldWidget.panes ||
      navigation != oldWidget.navigation ||
      orientation != oldWidget.orientation ||
      platform != oldWidget.platform ||
      device != oldWidget.device;

  @override
  bool updateShouldNotifyDependent(
    covariant WindowModel oldWidget,
    Set<WindowAspect> dependencies,
  ) {
    for (final aspect in dependencies) {
      switch (aspect) {
        case WindowAspect.device:
          if (device != oldWidget.device) return true;
          break;
        case WindowAspect.platform:
          if (platform != oldWidget.platform) return true;
          break;
        case WindowAspect.orientation:
          if (orientation != oldWidget.orientation) return true;
          break;
        case WindowAspect.navigation:
          if (navigation != oldWidget.navigation) return true;
          break;
        case WindowAspect.panes:
          if (panes != oldWidget.panes) return true;
          break;
      }
    }
    return false;
  }
}
