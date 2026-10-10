import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/material.dart';

void main() {
  test(
    'materialWindowBreakpoints has no coverage gaps across common widths',
    () {
      // Regression test: adjacent breakpoints used to leave gaps at
      // 839/840, 1199/1200, and 1599/1600, so a non-integer width like
      // 839.5 matched nothing and crashed firstWhere().
      for (double width = 0; width <= 2000; width += 0.5) {
        final mediaQuery = MediaQueryData(size: Size(width, 800));
        final matches = materialWindowBreakpoints.where(
          (breakpoint) => breakpoint.inRange(
            mediaQuery: mediaQuery,
            device: DeviceType.desktop,
            platform: PlatformType.macos,
          ),
        );
        expect(
          matches,
          isNotEmpty,
          reason: 'No WindowBreakpoint matched width $width',
        );
      }
    },
  );

  test('the tier at each shared boundary is pinned down', () {
    // The adjacent breakpoints intentionally overlap by exactly one point
    // at each boundary to avoid coverage gaps; firstWhere resolves the tie
    // to whichever entry is listed first. This test locks in which tier
    // that is, so a future reorder of the list is caught.
    const boundaryNavigation = {
      600: NavigationType.bottomBar,
      839: NavigationType.sideBar,
      1199: NavigationType.expandableSideBar,
      1599: NavigationType.expandableSideBar,
    };
    boundaryNavigation.forEach((width, expectedNavigation) {
      final breakpoint = materialWindowBreakpoints.firstWhere(
        (breakpoint) => breakpoint.inRange(
          mediaQuery: MediaQueryData(size: Size(width.toDouble(), 800)),
          device: DeviceType.desktop,
          platform: PlatformType.macos,
        ),
      );
      expect(breakpoint.navigation, expectedNavigation, reason: 'width $width');
    });
  });
}
