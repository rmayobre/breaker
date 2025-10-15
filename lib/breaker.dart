library;

import 'package:flutter/widgets.dart';

import 'src/layout/breaker_layout.dart';
import 'src/window/window_model.dart';
import 'src/window/window_type.dart';

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
export 'src/window/window_type.dart';

export 'src/breakpoint.dart';
export 'src/device_type.dart';
export 'src/platform_type.dart';

final class Breaker {

  static int panes(BuildContext context) => WindowModel.maybeOf(context)!.type.panes;
  static T window<T extends WindowType>(BuildContext context) => WindowModel.maybeOf<T>(context)!.type;

  static double? body(BuildContext context) => LayoutModel.of(context, LayoutAspect.body).body;
  static int span(BuildContext context) => LayoutModel.of(context, LayoutAspect.axes).axes;
  static double spanSize(BuildContext context) => LayoutModel.of(context, LayoutAspect.axisSize).axisSize;
  static double margin(BuildContext context) => LayoutModel.of(context, LayoutAspect.margin).margin;
  static double spacing(BuildContext context) => LayoutModel.of(context, LayoutAspect.spacing).spacing;
}