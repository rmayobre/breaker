library;

import 'package:flutter/widgets.dart';

import 'src/layout/breaker_layout.dart';
import 'src/window/navigation_type.dart';
import 'src/window/window_model.dart';
import 'src/device_type.dart';
import 'src/platform_type.dart';

export 'src/layout/breaker_layout.dart';
export 'src/layout/cell.dart';
export 'src/layout/layout_constraints.dart';
export 'src/layout/responsive_grid_layout.dart';
export 'src/layout/responsive_layout_builder.dart';
export 'src/layout/responsive_layout_overlay.dart';
export 'src/layout/responsive_vertical_layout.dart';
export 'src/layout/axis_calculator.dart';

export 'src/window/breaker_window.dart';
export 'src/window/window_model.dart';

export 'src/device_type.dart';
export 'src/layout_breakpoint.dart';
export 'src/platform_type.dart';
export 'src/window_breakpoint.dart';

final class Breaker {

  static DeviceType? device(BuildContext context) => WindowModel.of(context, WindowAspect.device).device;
  static PlatformType? platform(BuildContext context) => WindowModel.of(context, WindowAspect.platform).platform;
  static Orientation? orientation(BuildContext context) => WindowModel.of(context, WindowAspect.orientation).orientation;
  static NavigationType? navigation(BuildContext context) => WindowModel.of(context, WindowAspect.navigation).navigation;
  static int panes(BuildContext context) => WindowModel.of(context, WindowAspect.panes).panes;

  static double? body(BuildContext context) => LayoutModel.of(context, LayoutAspect.body).body;
  static int axes(BuildContext context) => LayoutModel.of(context, LayoutAspect.axes).axes;
  static double axisSize(BuildContext context) => LayoutModel.of(context, LayoutAspect.axisSize).axisSize;
  static double margin(BuildContext context) => LayoutModel.of(context, LayoutAspect.margin).margin;
  static double spacing(BuildContext context) => LayoutModel.of(context, LayoutAspect.spacing).spacing;
}