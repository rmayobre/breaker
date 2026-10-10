import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  group('LayoutConstraints.calculateMargin', () {
    test('returns 0 when both minMargin and maxMargin are 0', () {
      const breakpoint = LayoutBreakpoint(axes: 4, spacing: 4);
      expect(LayoutConstraints.calculateMargin(1000, 0, breakpoint), 0);
    });

    test(
      'centers a static body when maxMargin is 0, regardless of minMargin',
      () {
        const breakpoint = LayoutBreakpoint(minMargin: 32, axes: 4, spacing: 4);
        expect(LayoutConstraints.calculateMargin(1000, 800, breakpoint), 100);
      },
    );

    test(
      'returns minMargin when maxMargin is 0 and there is no body offset',
      () {
        const breakpoint = LayoutBreakpoint(minMargin: 16, axes: 4, spacing: 4);
        expect(LayoutConstraints.calculateMargin(1000, 0, breakpoint), 16);
      },
    );

    test(
      'interpolates between minMargin and maxMargin across the width range',
      () {
        const breakpoint = LayoutBreakpoint(
          minWidth: 900,
          maxWidth: 1100,
          minMargin: 32,
          maxMargin: 232,
          axes: 12,
          spacing: 12,
        );
        // Halfway between minWidth and maxWidth lands halfway between the margins.
        expect(LayoutConstraints.calculateMargin(1000, 0, breakpoint), 132);
      },
    );

    test(
      'falls back to minMargin instead of dividing by zero for a zero-width range',
      () {
        // Regression test: minWidth == maxWidth used to divide by zero,
        // producing NaN margins.
        const breakpoint = LayoutBreakpoint(
          minWidth: 900,
          maxWidth: 900,
          minMargin: 32,
          maxMargin: 232,
          axes: 12,
          spacing: 12,
        );
        expect(LayoutConstraints.calculateMargin(900, 0, breakpoint), 32);
      },
    );

    test(
      'falls back to minMargin instead of scaling across an unbounded range',
      () {
        // Regression test: an unset maxWidth (now defaulting to
        // double.infinity) used to make the percentage calculation divide by
        // an effectively-infinite range.
        const breakpoint = LayoutBreakpoint(
          minWidth: 1600,
          minMargin: 200,
          maxMargin: 400,
          axes: 12,
          spacing: 36,
        );
        expect(LayoutConstraints.calculateMargin(2000, 0, breakpoint), 200);
      },
    );
  });

  group('LayoutConstraints.calculateAxisSize', () {
    test('divides the available width evenly across axes and spacing', () {
      const breakpoint = LayoutBreakpoint(axes: 4, spacing: 10);
      // width 970 -> 3 gaps of 10 = 30 spacing; 940 left / 4 axes = 235.
      expect(LayoutConstraints.calculateAxisSize(970, breakpoint), 235);
    });
  });

  group('LayoutConstraints.calculateSpan', () {
    test('sums span widths and the spacing between them', () {
      const constraints = LayoutConstraints(
        axes: 12,
        axisSize: 60,
        margin: 16,
        spacing: 8,
      );
      // 4 axes: 4 * 60 + 3 * 8 = 240 + 24 = 264.
      expect(constraints.calculateSpan(4), 264);
    });
  });

  group('LayoutConstraints.fromBoxConstraints', () {
    test('uses a fixed body width and centers the margin around it', () {
      const breakpoint = LayoutBreakpoint(
        body: 800,
        minMargin: 32,
        axes: 12,
        spacing: 12,
      );
      final constraints = LayoutConstraints.fromBoxConstraints(
        constraints: const BoxConstraints(maxWidth: 1000),
        breakpoint: breakpoint,
      );
      expect(constraints.body, 800);
      expect(constraints.margin, 100); // (1000 - 800) / 2
    });

    test('scales the body to fill the available width minus margins', () {
      const breakpoint = LayoutBreakpoint(
        maxWidth: 600,
        minMargin: 16,
        axes: 4,
        spacing: 4,
      );
      final constraints = LayoutConstraints.fromBoxConstraints(
        constraints: const BoxConstraints(maxWidth: 400),
        breakpoint: breakpoint,
      );
      expect(constraints.body, isNull);
      expect(constraints.margin, 16);
    });
  });

  group('LayoutConstraints equality', () {
    test('constraints with identical fields are equal and hash equal', () {
      const a = LayoutConstraints(
        axes: 12,
        axisSize: 60,
        margin: 16,
        spacing: 8,
      );
      const b = LayoutConstraints(
        axes: 12,
        axisSize: 60,
        margin: 16,
        spacing: 8,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('constraints differing by a single field are not equal', () {
      const a = LayoutConstraints(
        axes: 12,
        axisSize: 60,
        margin: 16,
        spacing: 8,
      );
      const b = LayoutConstraints(
        axes: 12,
        axisSize: 80,
        margin: 16,
        spacing: 8,
      );
      expect(a, isNot(b));
    });
  });
}
