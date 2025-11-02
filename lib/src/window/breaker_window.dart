import 'dart:io';
// import 'dart:ui_web' show BrowserDetection;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'window_model.dart';
import '../device_type.dart';
import '../platform_type.dart';
import '../window_breakpoint.dart';

final class BreakerWindow extends StatefulWidget {
  const BreakerWindow({
    super.key,
    required this.breakpoints,
    required this.child
  });

  final List<WindowBreakpoint> breakpoints;

  final Widget child;

  @override
  State<StatefulWidget> createState() => BreakerWindowState();
}

final class BreakerWindowState extends State<BreakerWindow> {

  late WindowBreakpoint breakpoint;
  late DeviceType device;
  late PlatformType platform;

  @override
  void initState() {
    super.initState();
    // TODO move the global device reference to better support web and the BrowserDetection logic.
    if (Platform.isAndroid) {
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
    } else if (kIsWeb || kIsWasm) {
      device = DeviceType.web; // TODO revert back to mobile/desktop
      // device = BrowserDetection.instance.isMobile
      //     ? DeviceType.mobile
      //     : DeviceType.desktop;
      platform = PlatformType.web;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  void didChangeDependencies() {
    final mediaQuery = MediaQuery.of(context);
    breakpoint = widget.breakpoints
        .firstWhere((breakpoint) =>
          breakpoint.inRange(
            mediaQuery: mediaQuery, 
            device: device, 
            platform: platform,
          )
        );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WindowModel(
      device: breakpoint.device,
      platform: breakpoint.platform,
      orientation: breakpoint.orientation,
      navigation: breakpoint.navigation,
      panes: breakpoint.panes,
      child: widget.child,
    );
  }
}
