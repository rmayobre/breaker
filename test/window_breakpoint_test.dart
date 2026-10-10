import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  group('WindowBreakpoint', () {
    test('matches when size, orientation, device, and platform all match', () {
      const breakpoint = WindowBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        orientation: Orientation.landscape,
        device: DeviceType.desktop,
        platform: PlatformType.macos,
        panes: 2,
      );
      final mediaQuery = MediaQueryData(size: const Size(800, 600));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.desktop,
          platform: PlatformType.macos,
        ),
        isTrue,
      );
    });

    test('rejects a mismatched device even when size matches', () {
      const breakpoint = WindowBreakpoint(
        maxWidth: 900,
        device: DeviceType.mobile,
        panes: 1,
      );
      final mediaQuery = MediaQueryData(size: const Size(800, 600));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.desktop,
          platform: PlatformType.macos,
        ),
        isFalse,
      );
    });

    test('null filters match any device, platform, or orientation', () {
      const breakpoint = WindowBreakpoint(maxWidth: 900, panes: 1);
      final mediaQuery = MediaQueryData(size: const Size(500, 900));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.mobile,
          platform: PlatformType.android,
        ),
        isTrue,
      );
    });

    test('rejects size outside the min/max width bounds', () {
      const breakpoint = WindowBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        panes: 2,
      );
      final mediaQuery = MediaQueryData(size: const Size(500, 600));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.desktop,
          platform: PlatformType.linux,
        ),
        isFalse,
      );
    });

    test('rejects size outside the min/max height bounds', () {
      const breakpoint = WindowBreakpoint(
        minHeight: 600,
        maxHeight: 900,
        panes: 2,
      );
      final mediaQuery = MediaQueryData(size: const Size(800, 500));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.desktop,
          platform: PlatformType.linux,
        ),
        isFalse,
      );
    });

    test('rejects a mismatched orientation even when size matches', () {
      const breakpoint = WindowBreakpoint(
        orientation: Orientation.portrait,
        panes: 1,
      );
      // A wider-than-tall size is reported as landscape.
      final mediaQuery = MediaQueryData(size: const Size(800, 400));
      expect(
        breakpoint.inRange(
          mediaQuery: mediaQuery,
          device: DeviceType.mobile,
          platform: PlatformType.android,
        ),
        isFalse,
      );
    });
  });

  group('WindowBreakpoint equality', () {
    test('breakpoints with identical fields are equal and hash equal', () {
      const a = WindowBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        navigation: NavigationType.sideBar,
        panes: 2,
      );
      const b = WindowBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        navigation: NavigationType.sideBar,
        panes: 2,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('breakpoints differing by a single field are not equal', () {
      const a = WindowBreakpoint(maxWidth: 900, panes: 2);
      const b = WindowBreakpoint(maxWidth: 900, panes: 3);
      expect(a, isNot(b));
    });
  });
}
