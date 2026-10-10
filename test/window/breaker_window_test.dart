import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  testWidgets(
    'forwards the detected device/platform, not the breakpoint filters',
    (tester) async {
      // Regression test: BreakerWindow used to forward the matched
      // breakpoint's (nullable, usually-unset) device/platform filter
      // fields instead of the device/platform it actually detected.
      DeviceType? device;
      PlatformType? platform;

      await tester.pumpWidget(
        MaterialApp(
          home: BreakerWindow(
            breakpoints: const [
              // Intentionally does not set device/platform filters,
              // mirroring materialWindowBreakpoints and most real usage.
              WindowBreakpoint(panes: 1),
            ],
            child: Builder(
              builder: (context) {
                device = Breaker.device(context);
                platform = Breaker.platform(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(device, isNotNull);
      expect(platform, isNotNull);
    },
  );

  testWidgets('forwards the detected orientation, not the breakpoint filter', (
    tester,
  ) async {
    // Regression test: BreakerWindow forwarded breakpoint.orientation
    // (the nullable, usually-unset match filter) instead of the
    // orientation MediaQuery actually reports — the same bug already
    // fixed for device/platform, left unfixed for orientation.
    Orientation? orientation;

    await tester.pumpWidget(
      MaterialApp(
        home: BreakerWindow(
          breakpoints: const [
            // Intentionally does not set an orientation filter.
            WindowBreakpoint(panes: 1),
          ],
          child: Builder(
            builder: (context) {
              orientation = Breaker.orientation(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(orientation, isNotNull);
  });

  testWidgets('re-resolves the breakpoint when the window is resized', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);

    int? panes;

    await tester.pumpWidget(
      MaterialApp(
        home: BreakerWindow(
          breakpoints: const [
            WindowBreakpoint(maxWidth: 600, panes: 1),
            WindowBreakpoint(minWidth: 600, panes: 3),
          ],
          child: Builder(
            builder: (context) {
              panes = Breaker.panes(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(panes, 1);

    tester.view.physicalSize = const Size(1200, 800);
    await tester.pump();

    expect(panes, 3);
  });

  testWidgets('forwards navigation and panes from the matched breakpoint', (
    tester,
  ) async {
    NavigationType? navigation;
    int? panes;

    await tester.pumpWidget(
      MaterialApp(
        home: BreakerWindow(
          breakpoints: const [
            WindowBreakpoint(
              navigation: NavigationType.expandedSideBar,
              panes: 3,
            ),
          ],
          child: Builder(
            builder: (context) {
              navigation = Breaker.navigation(context);
              panes = Breaker.panes(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(navigation, NavigationType.expandedSideBar);
    expect(panes, 3);
  });

  testWidgets(
    'falls back to the first breakpoint when none match and no fallback is given',
    (tester) async {
      // Regression test: this used to throw a StateError. It should now
      // silently resolve to breakpoints.first instead of crashing.
      int? panes;
      NavigationType? navigation;

      await tester.pumpWidget(
        MaterialApp(
          home: BreakerWindow(
            breakpoints: const [
              WindowBreakpoint(
                maxWidth: 100,
                navigation: NavigationType.bottomBar,
                panes: 1,
              ),
              WindowBreakpoint(
                minWidth: 100,
                maxWidth: 200,
                navigation: NavigationType.sideBar,
                panes: 2,
              ),
            ],
            child: Builder(
              builder: (context) {
                panes = Breaker.panes(context);
                navigation = Breaker.navigation(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(panes, 1);
      expect(navigation, NavigationType.bottomBar);
    },
  );

  testWidgets(
    'uses the explicit fallback when none match, taking precedence over the first breakpoint',
    (tester) async {
      int? panes;
      NavigationType? navigation;

      await tester.pumpWidget(
        MaterialApp(
          home: BreakerWindow(
            breakpoints: const [
              WindowBreakpoint(
                maxWidth: 100,
                navigation: NavigationType.bottomBar,
                panes: 1,
              ),
            ],
            fallback: const WindowBreakpoint(
              navigation: NavigationType.expandedSideBar,
              panes: 5,
            ),
            child: Builder(
              builder: (context) {
                panes = Breaker.panes(context);
                navigation = Breaker.navigation(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(panes, 5);
      expect(navigation, NavigationType.expandedSideBar);
    },
  );

  test('requires at least one breakpoint', () {
    expect(
      () => BreakerWindow(breakpoints: const [], child: const SizedBox()),
      throwsA(isA<AssertionError>()),
    );
  });
}
