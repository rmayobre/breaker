import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  testWidgets('lays out multiple cells with spacing between them', (
    tester,
  ) async {
    // The test surface hands its child TIGHT constraints, so a SizedBox
    // nested directly under it doesn't get its requested size honored -
    // it's forcibly clamped to the surface size (default 800x600) whether
    // it asked for more or less. Widen the surface past 808 AND wrap the
    // SizedBox in Align, which turns those tight constraints loose so the
    // SizedBox can actually take the exact size it asks for.
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1000, 400);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 808,
            height: 200,
            child: ResponsiveVerticalLayout(
              breakpoints: const [LayoutBreakpoint(axes: 8, spacing: 8)],
              cells: [
                Cell(
                  span: (c) => (c.axes / 2).toInt(),
                  child: const SizedBox(),
                ),
                Cell(
                  span: (c) => (c.axes / 2).toInt(),
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final row = tester.widget<Row>(find.byType(Row));
    expect(row.children, hasLength(3)); // cell, spacer, cell

    final firstCell = row.children[0] as SizedBox;
    final spacer = row.children[1] as SizedBox;
    final secondCell = row.children[2] as SizedBox;

    // axes: 8, spacing: 8, no margin, width 808 -> axisSize 94.
    // Each cell spans 4 axes: 94 * 4 + 8 * 3 = 400.
    expect(firstCell.width, 400);
    expect(secondCell.width, 400);
    expect(spacer.width, 8);
  });

  test('requires at least one breakpoint', () {
    expect(
      () => ResponsiveVerticalLayout(breakpoints: const [], cells: const []),
      throwsA(isA<AssertionError>()),
    );
  });
}
