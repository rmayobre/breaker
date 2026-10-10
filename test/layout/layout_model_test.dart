import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';

LayoutModel _model({
  double? body,
  int axes = 4,
  double axisSize = 100,
  double margin = 16,
  double spacing = 8,
}) {
  return LayoutModel(
    body: body,
    axes: axes,
    axisSize: axisSize,
    margin: margin,
    spacing: spacing,
    child: const SizedBox(),
  );
}

void main() {
  group('LayoutModel.updateShouldNotify', () {
    test(
      'notifies when axisSize changes even if other fields are unchanged',
      () {
        // Regression test: axisSize used to be missing from this comparison,
        // so LayoutModel.maybeOf() dependents never rebuilt on an
        // axisSize-only change.
        final oldModel = _model(axisSize: 100);
        final newModel = _model(axisSize: 120);
        expect(newModel.updateShouldNotify(oldModel), isTrue);
      },
    );

    test('does not notify when nothing relevant changed', () {
      final oldModel = _model();
      final newModel = _model();
      expect(newModel.updateShouldNotify(oldModel), isFalse);
    });
  });

  group('LayoutModel.updateShouldNotifyDependent', () {
    test('notifies only dependents of the aspect that changed', () {
      final oldModel = _model(axisSize: 100);
      final newModel = _model(axisSize: 120);

      expect(
        newModel.updateShouldNotifyDependent(oldModel, {LayoutAspect.axisSize}),
        isTrue,
      );
      expect(
        newModel.updateShouldNotifyDependent(oldModel, {LayoutAspect.margin}),
        isFalse,
      );
    });
  });
}
