import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  testWidgets('resolves the matching breakpoint and exposes its constraints', (
    tester,
  ) async {
    late LayoutConstraints constraints;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 800,
          height: 600,
          child: ResponsiveLayoutBuilder(
            breakpoints: const [
              LayoutBreakpoint(maxWidth: 600, axes: 4, spacing: 4),
              LayoutBreakpoint(minWidth: 600, axes: 8, spacing: 8),
            ],
            builder: (context, layoutConstraints) {
              constraints = layoutConstraints;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(constraints.axes, 8);
    expect(constraints.spacing, 8);
  });

  testWidgets('matches a default breakpoint even under unbounded constraints', (
    tester,
  ) async {
    // Regression test for the LayoutBreakpoint double.infinity default: a
    // scrollable gives its child unbounded height.
    late LayoutConstraints constraints;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          child: ResponsiveLayoutBuilder(
            breakpoints: const [LayoutBreakpoint(axes: 4, spacing: 4)],
            builder: (context, layoutConstraints) {
              constraints = layoutConstraints;
              return const SizedBox(height: 10);
            },
          ),
        ),
      ),
    );

    expect(constraints.axes, 4);
  });

  testWidgets(
    'falls back to the first breakpoint when none match and no fallback is given',
    (tester) async {
      // Regression test: this used to throw a StateError. It should now
      // silently resolve to breakpoints.first instead of crashing.
      late LayoutConstraints constraints;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: ResponsiveLayoutBuilder(
              breakpoints: const [
                LayoutBreakpoint(maxWidth: 100, axes: 4, spacing: 4),
                LayoutBreakpoint(
                  minWidth: 100,
                  maxWidth: 200,
                  axes: 8,
                  spacing: 8,
                ),
              ],
              builder: (context, layoutConstraints) {
                constraints = layoutConstraints;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(constraints.axes, 4);
      expect(constraints.spacing, 4);
    },
  );

  testWidgets(
    'uses the explicit fallback when none match, taking precedence over the first breakpoint',
    (tester) async {
      late LayoutConstraints constraints;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: ResponsiveLayoutBuilder(
              breakpoints: const [
                LayoutBreakpoint(maxWidth: 100, axes: 4, spacing: 4),
              ],
              fallback: const LayoutBreakpoint(axes: 12, spacing: 24),
              builder: (context, layoutConstraints) {
                constraints = layoutConstraints;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(constraints.axes, 12);
      expect(constraints.spacing, 24);
    },
  );

  test('requires at least one breakpoint', () {
    expect(
      () => ResponsiveLayoutBuilder(
        breakpoints: const [],
        builder: (context, constraints) => const SizedBox(),
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
