import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

// A single breakpoint with a fixed (non-scaling) margin, so changing the
// width changes axisSize but not margin.
const _breakpoints = [LayoutBreakpoint(minMargin: 16, axes: 4, spacing: 8)];

class _ResizableBreakerLayout extends StatefulWidget {
  const _ResizableBreakerLayout({
    super.key,
    required this.initialWidth,
    required this.child,
  });

  final double initialWidth;
  final Widget child;

  @override
  State<_ResizableBreakerLayout> createState() =>
      _ResizableBreakerLayoutState();
}

class _ResizableBreakerLayoutState extends State<_ResizableBreakerLayout> {
  late double _width = widget.initialWidth;

  void resize(double width) => setState(() => _width = width);

  @override
  Widget build(BuildContext context) {
    // Align gives its child loose constraints, so the SizedBox below
    // actually gets to be _width wide instead of being clamped to the
    // test surface's tight constraints (which would make every resize a
    // no-op, since both 400 and 600 would be forced to the same surface
    // width).
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: _width,
        height: 600,
        // widget.child is never reconstructed across a setState-triggered
        // rebuild, so it stays the exact same widget instance below
        // BreakerLayout every time. That means the only way its
        // descendants can be marked dirty is through LayoutModel's own
        // InheritedModel notification path — not through ordinary
        // top-down widget-tree reconciliation.
        child: BreakerLayout(breakpoints: _breakpoints, child: widget.child),
      ),
    );
  }
}

void main() {
  testWidgets(
    'aspect-scoped dependents only rebuild when their aspect changes',
    (tester) async {
      // Regression test for the LayoutModel.updateShouldNotify fix: it used
      // to omit axisSize, so when only axisSize changed, InheritedModel's
      // whole-widget notify gate returned false and notifyClients() was
      // never called at all — meaning NO dependent rebuilt, not even the
      // one depending on axisSize itself.
      int axisSizeBuilds = 0;
      int marginBuilds = 0;

      final axisSizeConsumer = Builder(
        builder: (context) {
          axisSizeBuilds++;
          Breaker.axisSize(context);
          return const SizedBox();
        },
      );
      final marginConsumer = Builder(
        builder: (context) {
          marginBuilds++;
          Breaker.margin(context);
          return const SizedBox();
        },
      );

      final key = GlobalKey<_ResizableBreakerLayoutState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: _ResizableBreakerLayout(
            key: key,
            initialWidth: 400,
            child: Column(children: [axisSizeConsumer, marginConsumer]),
          ),
        ),
      );
      expect(axisSizeBuilds, 1);
      expect(marginBuilds, 1);

      key.currentState!.resize(600);
      await tester.pump();

      expect(axisSizeBuilds, 2);
      expect(marginBuilds, 1);
    },
  );

  test('requires at least one breakpoint', () {
    expect(
      () => BreakerLayout(breakpoints: const [], child: const SizedBox()),
      throwsA(isA<AssertionError>()),
    );
  });
}
