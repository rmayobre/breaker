import 'package:flutter/widgets.dart';

import '../device_type.dart';
import '../platform_type.dart';
import 'navigation_type.dart';

enum WindowAspect {
  device,
  platform,
  orientation,
  navigation,
  panes;
}

final class WindowModel extends InheritedModel<WindowAspect> {
  const WindowModel({
    super.key,
    required this.device,
    required this.platform,
    required this.orientation,
    required this.navigation,
    required this.panes,
    required super.child
  });

  static WindowModel of(BuildContext context, [WindowAspect? aspect]) => InheritedModel.inheritFrom(context, aspect: aspect)!;
  static DeviceType? deviceOf(BuildContext context) => of(context, WindowAspect.device).device;
  static PlatformType? platformOf(BuildContext context) => of(context, WindowAspect.platform).platform;
  static Orientation? orientationOf(BuildContext context) => of(context, WindowAspect.orientation).orientation;
  static NavigationType? navigationOf(BuildContext context) => of(context, WindowAspect.navigation).navigation;
  static int panesOf(BuildContext context) => of(context, WindowAspect.panes).panes;

  final DeviceType? device;
  final PlatformType? platform;
  final Orientation? orientation;
  final NavigationType? navigation;
  final int panes;

  @override
  bool updateShouldNotify(covariant WindowModel oldWidget) =>
      panes != oldWidget.panes
          || navigation != oldWidget.navigation
          || orientation != oldWidget.orientation
          || platform != oldWidget.platform
          || device != oldWidget.device;

  @override
  bool updateShouldNotifyDependent(
      covariant WindowModel oldWidget,
      Set<WindowAspect> dependencies) {
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