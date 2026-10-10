import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  group('LayoutBreakpoint', () {
    test('defaults span the full unbounded range', () {
      const breakpoint = LayoutBreakpoint(axes: 4, spacing: 8);
      expect(breakpoint.minHeight, 0);
      expect(breakpoint.maxHeight, double.infinity);
      expect(breakpoint.minWidth, 0);
      expect(breakpoint.maxWidth, double.infinity);
    });

    test('axes must be at least 1', () {
      expect(
        () => LayoutBreakpoint(axes: 0, spacing: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('inRange matches constraints within the min/max bounds', () {
      const breakpoint = LayoutBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        minHeight: 400,
        maxHeight: 800,
        axes: 8,
        spacing: 8,
      );
      expect(
        breakpoint.inRange(const BoxConstraints(maxWidth: 700, maxHeight: 600)),
        isTrue,
      );
    });

    test('inRange rejects constraints outside the min/max width bounds', () {
      const breakpoint = LayoutBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        axes: 8,
        spacing: 8,
      );
      expect(breakpoint.inRange(const BoxConstraints(maxWidth: 500)), isFalse);
      expect(breakpoint.inRange(const BoxConstraints(maxWidth: 1000)), isFalse);
    });

    test('inRange rejects constraints outside the min/max height bounds', () {
      const breakpoint = LayoutBreakpoint(
        minHeight: 400,
        maxHeight: 800,
        axes: 8,
        spacing: 8,
      );
      expect(breakpoint.inRange(const BoxConstraints(maxHeight: 300)), isFalse);
      expect(breakpoint.inRange(const BoxConstraints(maxHeight: 900)), isFalse);
    });

    test('a default breakpoint matches unbounded constraints', () {
      // Regression test: maxHeight/maxWidth used to default to
      // double.maxFinite, which rejected the double.infinity constraints a
      // LayoutBuilder reports inside an unbounded context (e.g. a
      // scrollable), crashing the widget that consumes it.
      const breakpoint = LayoutBreakpoint(axes: 4, spacing: 4);
      expect(
        breakpoint.inRange(
          const BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
          ),
        ),
        isTrue,
      );
    });
  });

  group('LayoutBreakpoint equality', () {
    test('breakpoints with identical fields are equal and hash equal', () {
      const a = LayoutBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        axes: 8,
        spacing: 8,
      );
      const b = LayoutBreakpoint(
        minWidth: 600,
        maxWidth: 900,
        axes: 8,
        spacing: 8,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('breakpoints differing by a single field are not equal', () {
      const a = LayoutBreakpoint(axes: 8, spacing: 8);
      const b = LayoutBreakpoint(axes: 12, spacing: 8);
      expect(a, isNot(b));
    });
  });
}
