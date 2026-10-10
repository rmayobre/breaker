import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

void main() {
  testWidgets(
    'builds a SizedBox sized by the axis calculator and constraints',
    (tester) async {
      const constraints = LayoutConstraints(
        axes: 12,
        axisSize: 60,
        margin: 16,
        spacing: 8,
      );
      final cell = Cell(span: (constraints) => 4, child: const SizedBox());

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) => cell.build(context, constraints),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, constraints.calculateSpan(4));
    },
  );
}
