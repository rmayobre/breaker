import 'dart:io';
// import 'dart:ui_web' show BrowserDetection;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'window_model.dart';
import '../breakpoint_resolver.dart';
import '../device_type.dart';
import '../platform_type.dart';
import '../window_breakpoint.dart';

final class BreakerWindow extends StatefulWidget {
  const BreakerWindow({
    super.key,
    required this.breakpoints,
    this.fallback,
    required this.child,
  }) : assert(
         breakpoints.length > 0,
         'BreakerWindow requires at least one WindowBreakpoint.',
       );

  final List<WindowBreakpoint> breakpoints;

  /// Used when no entry in [breakpoints] matches the current window. If
  /// null, the first entry in [breakpoints] is used instead.
  final WindowBreakpoint? fallback;

  final Widget child;

  @override
  State<StatefulWidget> createState() => BreakerWindowState();
}

final class BreakerWindowState extends State<BreakerWindow> {
  late WindowBreakpoint breakpoint;
  late DeviceType device;
  late PlatformType platform;
  late Orientation orientation;

  @override
  void initState() {
    super.initState();
    // TODO move the global device reference to better support web and the BrowserDetection logic.
    // kIsWeb must be checked before touching dart:io's Platform: on web, every
    // Platform.* getter throws UnsupportedError at runtime (it compiles fine,
    // but crashes the instant it's read), so it can never be checked first.
    if (kIsWeb || kIsWasm) {
      device = DeviceType.web; // TODO revert back to mobile/desktop
      // device = BrowserDetection.instance.isMobile
      //     ? DeviceType.mobile
      //     : DeviceType.desktop;
      platform = PlatformType.web;
    } else if (Platform.isAndroid) {
      device = DeviceType.mobile;
      platform = PlatformType.android;
    } else if (Platform.isIOS) {
      device = DeviceType.mobile;
      platform = PlatformType.ios;
    } else if (Platform.isLinux) {
      device = DeviceType.desktop;
      platform = PlatformType.linux;
    } else if (Platform.isMacOS) {
      device = DeviceType.desktop;
      platform = PlatformType.macos;
    } else if (Platform.isWindows) {
      device = DeviceType.desktop;
      platform = PlatformType.windows;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  void didChangeDependencies() {
    final mediaQuery = MediaQuery.of(context);
    orientation = mediaQuery.orientation;
    breakpoint = resolveBreakpoint<WindowBreakpoint>(
      breakpoints: widget.breakpoints,
      matches: (breakpoint) => breakpoint.inRange(
        mediaQuery: mediaQuery,
        device: device,
        platform: platform,
      ),
      fallback: widget.fallback,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WindowModel(
      device: device,
      platform: platform,
      orientation: orientation,
      navigation: breakpoint.navigation,
      panes: breakpoint.panes,
      child: widget.child,
    );
  }
}
