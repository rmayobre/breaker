import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/material.dart';

void main() {
  test(
    'materialLayoutBreakpoints has no coverage gaps across common widths',
    () {
      // Regression test: adjacent breakpoints used to leave a gap between
      // e.g. maxWidth: 599 and the next breakpoint's minWidth: 600, so a
      // non-integer width like 599.5 matched nothing and crashed
      // firstWhere().
      for (double width = 0; width <= 2000; width += 0.5) {
        final constraints = BoxConstraints(maxWidth: width);
        final matches = materialLayoutBreakpoints.where(
          (breakpoint) => breakpoint.inRange(constraints),
        );
        expect(
          matches,
          isNotEmpty,
          reason: 'No LayoutBreakpoint matched width $width',
        );
      }
    },
  );

  test('the tier at each shared boundary is pinned down', () {
    // The adjacent breakpoints intentionally overlap by exactly one point
    // at each boundary to avoid coverage gaps; firstWhere resolves the tie
    // to whichever entry is listed first. axes ties at 1240/1440 (both
    // sides are 12), so spacing is used instead to actually distinguish
    // the tier. This test locks in which tier wins, so a future reorder
    // of the list is caught.
    const boundarySpacing = {600: 4, 905: 8, 1240: 12, 1440: 24};
    boundarySpacing.forEach((width, expectedSpacing) {
      final breakpoint = materialLayoutBreakpoints.firstWhere(
        (breakpoint) =>
            breakpoint.inRange(BoxConstraints(maxWidth: width.toDouble())),
      );
      expect(breakpoint.spacing, expectedSpacing, reason: 'width $width');
    });
  });
}
