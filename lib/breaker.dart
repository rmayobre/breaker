/// A responsive and adaptive layout framework for Flutter built on a
/// breakpoint system.
///
/// Two independent breakpoint systems are provided:
///
///  * **Window breakpoints** ([WindowBreakpoint], resolved by [BreakerWindow])
///    describe the window as a whole: device, platform, orientation, navigation
///    style and number of panes.
///  * **Layout breakpoints** ([LayoutBreakpoint], resolved by [BreakerLayout]
///    or [ResponsiveLayoutBuilder]) describe a column grid: body width, number
///    of axes (columns), margins and spacing.
///
/// Descendants read the resolved values through the static accessors on
/// [Breaker]. For ready-made Material Design breakpoints, import
/// `package:breaker/material.dart` instead.
library;

import 'package:flutter/widgets.dart';

import 'src/layout/layout_model.dart';
import 'src/window/navigation_type.dart';
import 'src/window/window_model.dart';
import 'src/device_type.dart';
import 'src/platform_type.dart';

export 'src/layout/breaker_layout.dart';
export 'src/layout/cell.dart';
export 'src/layout/layout_constraints.dart';
export 'src/layout/layout_model.dart';
export 'src/layout/responsive_grid_layout.dart';
export 'src/layout/responsive_layout_builder.dart';
export 'src/layout/responsive_layout_overlay.dart';
export 'src/layout/responsive_vertical_layout.dart';

export 'src/window/breaker_window.dart';
export 'src/window/navigation_type.dart';

export 'src/device_type.dart';
export 'src/layout_breakpoint.dart';
export 'src/platform_type.dart';
export 'src/window_breakpoint.dart';

/// Static accessors for the values resolved by the nearest [BreakerWindow] and
/// [BreakerLayout] ancestors.
///
/// Each accessor registers a dependency on only the aspect it reads, so a
/// widget rebuilds only when that particular value changes.
///
/// The window accessors ([device], [platform], [orientation], [navigation],
/// [panes]) require a [BreakerWindow] ancestor; the layout accessors ([body],
/// [axes], [axisSize], [margin], [spacing]) require a [BreakerLayout]
/// ancestor. Calling one without its ancestor throws a null-check error.
final class Breaker {
  /// The [DeviceType] of the running device.
  static DeviceType? device(BuildContext context) =>
      WindowModel.of(context, WindowAspect.device).device;
  /// The [PlatformType] of the running platform.
  static PlatformType? platform(BuildContext context) =>
      WindowModel.of(context, WindowAspect.platform).platform;
  /// The current window [Orientation].
  static Orientation? orientation(BuildContext context) =>
      WindowModel.of(context, WindowAspect.orientation).orientation;
  /// The [NavigationType] of the active [WindowBreakpoint], or null if the
  /// breakpoint doesn't specify one.
  static NavigationType? navigation(BuildContext context) =>
      WindowModel.of(context, WindowAspect.navigation).navigation;
  /// The number of panes supported by the active [WindowBreakpoint].
  static int panes(BuildContext context) =>
      WindowModel.of(context, WindowAspect.panes).panes;

  /// The fixed body width of the active [LayoutBreakpoint], or null when the
  /// body scales with the available width.
  static double? body(BuildContext context) =>
      LayoutModel.of(context, LayoutAspect.body).body;
  /// The number of axes (columns) of the active [LayoutBreakpoint].
  static int axes(BuildContext context) =>
      LayoutModel.of(context, LayoutAspect.axes).axes;
  /// The size of a single axis (column), excluding spacing.
  static double axisSize(BuildContext context) =>
      LayoutModel.of(context, LayoutAspect.axisSize).axisSize;
  /// The margin applied to each side of the body.
  static double margin(BuildContext context) =>
      LayoutModel.of(context, LayoutAspect.margin).margin;
  /// The spacing between adjacent axes.
  static double spacing(BuildContext context) =>
      LayoutModel.of(context, LayoutAspect.spacing).spacing;
}
