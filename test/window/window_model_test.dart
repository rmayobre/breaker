import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaker/breaker.dart';
// WindowModel/WindowAspect are an implementation detail not exported from
// package:breaker/breaker.dart; reach in directly for this internal test.
import 'package:breaker/src/window/window_model.dart';

WindowModel _model({
  DeviceType? device = DeviceType.desktop,
  PlatformType? platform = PlatformType.macos,
  Orientation? orientation = Orientation.landscape,
  NavigationType? navigation = NavigationType.sideBar,
  int panes = 2,
}) {
  return WindowModel(
    device: device,
    platform: platform,
    orientation: orientation,
    navigation: navigation,
    panes: panes,
    child: const SizedBox(),
  );
}

void main() {
  group('WindowModel.updateShouldNotify', () {
    test('notifies when any tracked field changes', () {
      final oldModel = _model(navigation: NavigationType.sideBar);
      final newModel = _model(navigation: NavigationType.bottomBar);
      expect(newModel.updateShouldNotify(oldModel), isTrue);
    });

    test('does not notify when nothing changed', () {
      final oldModel = _model();
      final newModel = _model();
      expect(newModel.updateShouldNotify(oldModel), isFalse);
    });
  });

  group('WindowModel.updateShouldNotifyDependent', () {
    test('notifies only dependents of the aspect that changed', () {
      final oldModel = _model(panes: 2);
      final newModel = _model(panes: 3);

      expect(
        newModel.updateShouldNotifyDependent(oldModel, {WindowAspect.panes}),
        isTrue,
      );
      expect(
        newModel.updateShouldNotifyDependent(oldModel, {
          WindowAspect.navigation,
        }),
        isFalse,
      );
    });
  });
}
