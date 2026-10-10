import 'package:flutter_test/flutter_test.dart';

// resolveBreakpoint is an implementation detail not exported from
// package:breaker/breaker.dart; reach in directly for this internal test.
import 'package:breaker/src/breakpoint_resolver.dart';

void main() {
  group('resolveBreakpoint', () {
    test('returns the first matching element', () {
      final result = resolveBreakpoint<int>(
        breakpoints: [1, 2, 3],
        matches: (breakpoint) => breakpoint == 2,
      );
      expect(result, 2);
    });

    test('matching takes precedence over a fallback', () {
      final result = resolveBreakpoint<int>(
        breakpoints: [1, 2, 3],
        matches: (breakpoint) => breakpoint == 3,
        fallback: 99,
      );
      expect(result, 3);
    });

    test('returns the fallback when nothing matches and one is given', () {
      final result = resolveBreakpoint<int>(
        breakpoints: [1, 2, 3],
        matches: (breakpoint) => false,
        fallback: 99,
      );
      expect(result, 99);
    });

    test(
      'returns the first element when nothing matches and no fallback is given',
      () {
        final result = resolveBreakpoint<int>(
          breakpoints: [1, 2, 3],
          matches: (breakpoint) => false,
        );
        expect(result, 1);
      },
    );
  });
}
