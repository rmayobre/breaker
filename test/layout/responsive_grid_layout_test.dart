import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  testWidgets(
    'falls back to the explicit fallback when none match, forwarding constraints to axisCount',
    (tester) async {
      LayoutConstraints? seenConstraints;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: ResponsiveGridLayout(
              breakpoints: const [
                LayoutBreakpoint(maxWidth: 100, axes: 4, spacing: 4),
              ],
              fallback: const LayoutBreakpoint(axes: 12, spacing: 24),
              axisCount: (constraints) {
                seenConstraints = constraints;
                return constraints.axes;
              },
              itemBuilder: (context, index) => const SizedBox(),
            ),
          ),
        ),
      );

      expect(seenConstraints, isNotNull);
      expect(seenConstraints!.axes, 12);
      expect(seenConstraints!.spacing, 24);
    },
  );

  test('requires at least one breakpoint', () {
    expect(
      () => ResponsiveGridLayout(
        breakpoints: const [],
        axisCount: (constraints) => constraints.axes,
        itemBuilder: (context, index) => const SizedBox(),
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
